# LLM Project Scaffolding — Minimum Viable Specification Framework

> **Date:** 2026-06-10  
> **Purpose:** A meta-document analyzing what specifications PawFinder had vs. what was needed to avoid token-wasting fix cycles. A blueprint for oneshotting projects with LLMs.

---

## The Core Problem

You started with three documents:

| Document | What It Covers | Grade |
|----------|---------------|-------|
| **SDLC Spec** | Functional requirements, user stories, architecture diagram, development phases | Good for WHAT |
| **Design Guide** | Color palette, typography, spacing, component specs, screen wireframes | Good for HOW IT LOOKS |
| **Dependencies List** | All Flutter + Spring Boot packages with versions | Good for WHAT TO INSTALL |

These three got us 80% of the way — the scaffolded code *looked* correct. Every class was in the right package, every widget had the right constructor, every service had its port assigned. But when we tried to **run** it, we spent 3 hours fixing 8 runtime failures that all traced back to the same root cause: **specifications that described intent but not concrete implementation details.**

---

## What Was Missing — The 5 Missing Document Types

### ❌ Missing Doc #1: Concrete Database Schema (DDL)

**What the SDLC had:**
```
An ASCII architecture diagram showing "PostgreSQL + PostGIS" as a box.
Entity names mentioned in user stories: Alert, Pet, User, Sighting, Message.
```

**What was needed:**
A table-level schema specification that locks in column names, types, constraints, and PostGIS geometry columns **before** LLM code generation. This single document would have prevented 5 of the 8 runtime failures.

**Real chokeholds caused by this absence:**
| Failure | Root Cause |
|---------|-----------|
| `missing column [last_seen_location] in table [alerts]` | Entity used `GEOGRAPHY(Point,4326)` but migration created `DOUBLE PRECISION` lat/lng columns |
| `missing column [location] in table [sightings]` | Same PostGIS vs. lat/lng mismatch |
| `wrong column type [photos] — found jsonb, expecting text` | Entity declared `TEXT` but migration created `JSONB` |
| `wrong column type [photo_urls] — found jsonb, expecting text` | Same JSONB vs. TEXT mismatch |
| `missing table [daily_metrics]` | Table existed in entity but no migration was run for it |

**The fix document would look like:**
```sql
-- Table: alerts
-- Owned by: alert-service (migration V3)
-- Shared via: pawfinder-shared domain entity
CREATE TABLE alerts (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id        UUID NOT NULL REFERENCES pets(id),
    owner_id      UUID NOT NULL REFERENCES users(id),
    status        VARCHAR(20) DEFAULT 'active',
    -- ⚠️ PostGIS GEOGRAPHY, NOT DOUBLE PRECISION
    last_seen_location  GEOGRAPHY(Point, 4326),  
    last_seen_address   TEXT,
    last_seen_timestamp TIMESTAMP,
    description   TEXT,
    reward_amount       DECIMAL(10,2),
    -- ⚠️ Column name: reward_currency, type: VARCHAR(3)
    reward_currency     VARCHAR(3) DEFAULT 'USD',
    -- ⚠️ Column name: photos, type: JSONB (NOT TEXT)
    photos        JSONB,
    -- ... etc
);
```

**Why LLMs need this:** An LLM generates JPA entities and Flyway migrations in *different passes*. Without a single source of truth for column types, the entity pass says `TEXT` while the migration pass says `JSONB`. The LLM doesn't "remember" the inconsistency across turns.

---

### ❌ Missing Doc #2: Service Dependency & Module Boundary Map

**What the SDLC had:**
```
An ASCII box diagram showing service names and ports.
```

**What was needed:**
A matrix specifying:
- Which services include `pawfinder-shared` (answer: all of them)
- Which services need `spring-boot-starter-data-jpa` (answer: auth, alert, messaging, analytics, reward)
- Which services do NOT need a database (answer: api-gateway, media-service, notification-service)
- Which services need `spring-boot-starter-webflux` vs. `spring-boot-starter-web` (answer: api-gateway needs reactive)
- Which services own which Flyway migrations
- Flyway history table names per service

**Real chokeholds caused by this absence:**
| Failure | Root Cause |
|---------|-----------|
| Media service: `Failed to configure a DataSource` | Shared module pulls in JPA transitively. Media service only needs S3, not a DB. No exclusion configured. |
| API Gateway: `Failed to configure a DataSource` | Same JPA auto-config issue. |
| API Gateway: `Spring MVC incompatible with Spring Cloud Gateway` | Shared module pulls in Spring MVC. Gateway needs WebFlux. |

**The fix document would look like:**
```
Service Dependency Matrix:
┌─────────────────────┬──────────┬──────┬──────┬──────────┬───────────┐
│ Service             │ Needs DB?│ JPA? │ MVC? │ Flyway?  │ Shared?   │
├─────────────────────┼──────────┼──────┼──────┼──────────┼───────────┤
│ api-gateway (8080)  │ ❌       │ ❌   │ ❌*  │ ❌       │ ⚠️ exclude│
│ auth-service (8081) │ ✅       │ ✅   │ ✅   │ ✅ V1    │ ✅        │
│ alert-service (8082)│ ✅       │ ✅   │ ✅   │ ✅ V1-V6 │ ✅        │
│ messaging (8083)    │ ✅       │ ✅   │ ✅   │ ✅ V5-V6 │ ✅        │
│ reward (8084)       │ ✅       │ ✅   │ ✅   │ ❌       │ ✅        │
│ media (8085)        │ ❌       │ ❌   │ ✅   │ ❌       │ ⚠️ exclude│
│ analytics (8086)    │ ✅       │ ✅   │ ✅   │ ✅ V7    │ ✅        │
│ matching (8087)     │ ✅       │ ✅   │ ✅   │ ❌       │ ✅        │
│ notification (8088) │ ❌       │ ❌   │ ✅   │ ❌       │ ⚠️ exclude│
└─────────────────────┴──────────┴──────┴──────┴──────────┴───────────┘
* api-gateway: spring.main.web-application-type=reactive
⚠️ exclude = needs DataSourceAutoConfiguration + HibernateJpaAutoConfiguration excluded
```

**Why LLMs need this:** LLMs see `pawfinder-shared` on the classpath and assume "this service has JPA → needs a DataSource." They don't infer that a media service *shouldn't* have a database unless explicitly told.

---

### ❌ Missing Doc #3: Environment Variable & Configuration Specification

**What existed:**
```
.env.example — a template with placeholder values.
```

**What was needed:**
A per-service map of which env vars are consumed, which service reads them, and fallback defaults. This prevents:
- Starting a service without required credentials
- Credential name mismatches between `.env` and `application.yml`
- Forgetting to pass env vars when starting services individually

**Real chokeholds caused by this absence:**
| Issue | Impact |
|-------|--------|
| Reward service needed `STRIPE_SECRET_KEY` but we had `mk_` prefix keys initially | Service would fail on Stripe API call |
| Notification service needed `FIREBASE_SERVER_KEY` — unclear if the google-services.json API key works for FCM | Unknown until tested |
| Services started individually required manual env var injection each time | 9 services × 25 env vars = friction |

---

### ❌ Missing Doc #4: Build Dependency Graph & POM Specification

**What the Dependencies doc had:**
```
A comprehensive list of all Flutter + Maven dependencies with versions.
```

**What was needed:**
A per-module POM specification showing:
- Which Spring Boot starters each service needs
- Which infrastructure dependencies (Flyway, PostGIS, Hibernate Spatial) each service needs
- Explicit exclusions (e.g., analytics-service needs `flyway-core` but doesn't have it)

**Real chokeholds caused by this absence:**
| Failure | Root Cause |
|---------|-----------|
| Analytics service has V7 migration but Flyway never runs | `pom.xml` missing `flyway-core` + `flyway-postgresql` dependencies |
| API Gateway has `spring-boot-starter-web` from shared, causing MVC conflict | No exclusion configured in gateway pom |

---

### ❌ Missing Doc #5: Infrastructure & DevOps Specification

**What existed:**
```
docker-compose.yml with PostgreSQL, Redis, RabbitMQ, Elasticsearch.
```

**What was needed:**
- Explicit port mapping decisions (5433 vs 5432 — we hit this in a previous session)
- PostgreSQL auth method (`trust` for dev, not production)
- PostGIS extension requirement (needed for `GEOGRAPHY` columns)
- Service startup order (alert service first to run migrations, then others)
- Health check endpoints per service

---

## The Scaffolding Document Stack — What You Need to Oneshot

For a full-stack Flutter + Spring Boot microservices app, here's the complete document stack ranked by impact:

### Tier 1 — Must Have (Product Definition)
These you had. They define **what** to build.

| # | Document | Contents |
|---|----------|----------|
| 1 | **SDLC / Requirements Spec** | User stories, functional requirements, non-functional requirements, user personas, wireframes |
| 2 | **Design System** | Color tokens, typography, spacing scale, component specs, dark/light themes, animation language |

### Tier 2 — Must Have (Technical Specification)
These you were missing. They define **how** to build it at the implementation level.

| # | Document | Contents | Prevents |
|---|----------|----------|----------|
| 3 | **Database Schema (DDL)** | Every table, column name, column type, constraints, PostGIS geometry columns, indexes, foreign keys | Schema mismatches (5 of 8 failures) |
| 4 | **Service Boundary Map** | Per-service: DB ownership, JPA needs, Flyway config, exclusions, web type (MVC vs reactive) | Bootstrap failures (3 of 8 failures) |
| 5 | **API Contract (OpenAPI/REST)** | Every endpoint, HTTP method, path, request/response DTOs, status codes, auth requirements | DTO mismatches, missing endpoints |

### Tier 3 — Should Have (Dependencies & Config)

| # | Document | Contents | Prevents |
|---|----------|----------|----------|
| 6 | **Environment Variable Spec** | Per-service env var map, where each key is consumed, fallback defaults | Credential wiring issues |
| 7 | **Build Dependency Matrix** | Per-module POM specification, explicit dependency exclusions | Missing Flyway, MVC/WebFlux conflicts |
| 8 | **Infrastructure Spec** | Port map, auth methods, volumes, startup order, health checks | Port conflicts, auth failures |

### Tier 4 — Nice to Have (Operations)

| # | Document | Contents |
|---|----------|----------|
| 9 | **Secret Inventory** | Every API key needed, where to get it, where it goes, format validation |
| 10 | **Startup & Run Guide** | Exact commands to build, start, verify, and debug the full system |

---

## Why LLMs Need Concrete Specs More Than Humans

A human developer fills gaps with intuition. An LLM fills gaps with *hallucination*:

| Human | LLM |
|-------|-----|
| Sees `last_seen_location` and `last_seen_latitude` → "these should match" | Generates entity in one pass, migration in another → doesn't cross-reference |
| Sees `pawfinder-shared` on classpath → "does this service actually need JPA?" | Sees JPA on classpath → "must need a DataSource" |
| Reads `docker-compose.yml` → notices port 5432 is taken | Generates config with default 5432 → doesn't check host |
| Knows Spring Cloud Gateway needs WebFlux | Uses `spring-boot-starter-web` from shared → MVC conflict |

**The rule:** Every implementation detail that two different code artifacts must agree on (entity ↔ migration, service ↔ dependency, config ↔ env var) needs to be specified **once** in a source-of-truth document that the LLM can reference during every generation pass.

---

## The Minimum Viable Spec Stack (TL;DR)

To oneshot a full-stack app without fix cycles, create these **6 documents before writing a single line of code:**

1. **Requirements Spec** — User stories, functional requirements, wireframes ✅ (you had this)
2. **Design System** — Colors, typography, components, themes ✅ (you had this)
3. **Database Schema (DDL)** — Every column name, type, constraint ❌ (missing)
4. **Service Boundary Map** — DB ownership, dependency matrix, exclusions ❌ (missing)
5. **API Contract** — Every endpoint, DTO, status code ❌ (missing)
6. **Infrastructure Spec** — Ports, auth, startup order, health checks ❌ (partial)

Documents 3 and 4 alone would have prevented every single runtime failure we debugged today.

---

*Written by Claw after a 3-hour fix session that could have been 30 minutes.*
