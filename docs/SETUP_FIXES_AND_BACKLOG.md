# Paws Project — Setup Fix Documentation & Backlog

> **Date:** 2026-06-09  
> **Session:** Backend infrastructure + Enhanced UI Design System v2 implementation

---

## 1. Docker Infrastructure Fixes

### 1.1 Docker Desktop Not Running
**Issue:** Docker daemon was not started on Windows. `docker ps` returned "The system cannot find the file specified."

**Fix:** Started Docker Desktop. Docker daemon initialized successfully (v29.2.1, Compose v5.1.0).

### 1.2 Docker Images Pulled
Pulled 4 infrastructure images defined in `docker-compose.yml`:
- `postgis/postgis:15-3.4` — PostgreSQL 15 with PostGIS for geospatial queries
- `redis:7.2-alpine` — Caching, sessions, rate limiting
- `rabbitmq:3.12-management-alpine` — Async event messaging between microservices
- `elasticsearch:8.12.0` — Full-text search for alerts/pets

### 1.3 docker-compose.yml Cleanup
**Issue:** Deprecated `version: '3.8'` attribute caused warnings in Docker Compose v5.

**Fix:** Removed the `version` attribute (now ignored by modern Docker Compose).

### 1.4 Local PostgreSQL Port Conflict 🔴 CRITICAL
**Issue:** A Windows service `postgresql-x64-17` (PostgreSQL 17) was occupying port 5432. Docker's port forwarding couldn't bind, so the Spring Boot services connected to the WRONG PostgreSQL instance, causing "password authentication failed for user pawfinder" errors.

**Diagnosis:** `netstat -ano | findstr ":5432"` revealed two processes on 5432:
- PID 6696: `postgres.exe` (Windows PostgreSQL 17 service)
- PID 18996: `com.docker.backend.exe` (Docker's port forwarding)

**Fix:**
1. Changed Docker PostgreSQL port mapping from `5432:5432` to `5433:5432`
2. Updated `POSTGRES_URL` in `.env` from `localhost:5432` to `localhost:5433`
3. Updated default JDBC URLs in all 6 service `application.yml` files from `5432` to `5433`

### 1.5 PostgreSQL Authentication
**Issue:** The Docker container's pg_hba.conf used `scram-sha-256` for external connections. When port forwarding routes through Docker's bridge network, connections hit the catch-all rule requiring password auth, which doesn't match the trust settings on localhost.

**Fix:** Added `POSTGRES_HOST_AUTH_METHOD: trust` to `docker-compose.yml` service environment. Recreated the PostgreSQL container from scratch (removed volume) to apply the setting.

---

## 2. Backend Microservice Fixes

### 2.1 Flyway Migration Conflicts 🔴 CRITICAL
**Issue:** Multiple services share the same `pawfinder` database but have overlapping Flyway migration version numbers:
- Auth service: V1
- Alert service: V1, V2, V3, V4
- Messaging service: V5, V6
- Analytics service: V7

All pointing at the same `flyway_schema_history` table causes conflicts (V1 exists in both auth and alert).

**Fix:** Configured each service with a unique Flyway history table name:
```yaml
# Each service gets its own history table:
flyway.table: flyway_auth_history        # Auth
flyway.table: flyway_alert_history       # Alert
flyway.table: flyway_messaging_history   # Messaging
flyway.table: flyway_analytics_history   # Analytics
```

### 2.2 Database Credentials Mismatch
**Issue:** Auth and Messaging services had default credentials `postgres/root` in their YAML configs, but the Docker container uses `pawfinder/pawfinder_dev`.

**Fix:** Updated default credentials in auth-service and messaging-service `application.yml`:
```yaml
username: ${POSTGRES_USER:pawfinder}
password: ${POSTGRES_PASSWORD:*** # fixed in edit
```

### 2.3 Hibernate Schema Validation Failures
**Issue:** `ddl-auto: validate` caused all services to fail because Hibernate validates ALL entities scanned via `@EntityScan("com.pawfinder.shared.domain")` against the database schema. Auth service only owns the `users` table but shared entities include `alerts`, `pets`, etc.

**Fix:** Changed `ddl-auto` from `validate` to `none` on services that use shared domain entities but only own a subset of tables:
- auth-service: `none`
- alert-service: `none`
- messaging-service: `none`

Services with `flyway.enabled: false` (matching, reward) have `ddl-auto: none` already.

### 2.4 Flyway Baseline for Shared Schema
**Issue:** Alert, messaging, and analytics services failed with "Found non-empty schema(s) public but no schema history table" because the public schema already contained tables from other services' migrations.

**Fix:** Added `baseline-on-migrate: true` and `baseline-version: 0` to alert, messaging, and analytics Flyway configs.

### 2.5 Notification Service DataSource Error
**Issue:** Notification service has `spring-boot-starter-data-jpa` on classpath (from pawfinder-shared dependency) but doesn't need a database. Spring Boot auto-configuration tried to create a DataSource and failed.

**Fix:** Excluded `DataSourceAutoConfiguration` in `NotificationServiceApplication.java`:
```java
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
```

### 2.6 Notification Service RabbitMQ Queue Not Found
**Issue:** The queue `pawfinder.notification.queue` didn't exist in RabbitMQ vhost `/`. The listener container used passive queue declaration (expects queue to already exist).

**Fix:** Added to notification service `application.yml`:
```yaml
spring.rabbitmq.listener.simple:
  missing-queues-fatal: false
  auto-startup: false
```

---

## 3. Frontend Enhanced Design System (v2)

### 3.1 Color Palette: Warm Paper
| Token | Old (v1) | New (v2) | Rationale |
|-------|----------|----------|-----------|
| Background | `#FFFFFF` | `#FFFBF5` (paper) | Warm cream, not clinical white |
| Surface | `#F7F7F9` | `#FFF5EB` (card) | Actually warm, not grey |
| Primary | `#FF6B35` | `#E8612D` (clay) | Richer, more grounded |
| Secondary | `#4ECDC4` | `#5B9A8B` (sage) | Calmer, more natural |
| Text | `#1A1A2E` | `#2D241F` (ink900) | Warm brown-black |
| Dark bg | `#12121E` | `#1A1815` (paperDark) | Warm charcoal |

### 3.2 Typography: Outfit + Plus Jakarta Sans
Replaced `Inter` (overused AI font) with:
- **Outfit** — Display voice for headings, CTAs
- **Plus Jakarta Sans** — Body voice for paragraphs, metadata

### 3.3 New Dependencies
- `google_fonts: ^6.1.0` added to pubspec.yaml

### 3.4 New Widgets
- `TexturedBackground` — Subtle noise grain over warm paper
- `PawPrint` — Custom vector paw print painter
- `PawPrintLoader` — Walking paw print animation loader
- `PawFinderApp` (updated `app.dart`) — Uses new `AppTheme`

### 3.5 Backward Compatibility
Old color constants retained as aliases:
```dart
static const Color background = paper;
static const Color surface = card;
static const Color ink100 = border;
static const Color ink300 = border;
static const Color rewardDark = reward;
```

---

## 4. Services Running Successfully

| Service | Port | DB Tables | Status |
|---------|------|-----------|--------|
| pawfinder-auth-service | 8081 | `users` | ✅ |
| pawfinder-alert-service | 8082 | `pets`, `alerts`, `sightings` | ✅ |
| pawfinder-messaging-service | 8083 | `conversations`, `messages` + STOMP | ✅ |
| pawfinder-notification-service | 8088 | (no DB, RabbitMQ only) | ✅ |

---

## 5. Remaining Backlog

### High Priority
- [ ] **Flutter run diagnosis** — `flutter run` doesn't work on the host. Investigate emulator/device setup, Flutter doctor issues, or build configuration.
- [ ] **Analytics Service (8086)** — Ready to start, Flyway V7 creates `daily_metrics` table. Needs `spring-boot:run`.
- [ ] **API Gateway (8080)** — Spring Cloud Gateway. Needs all upstream services configured.

### Medium Priority
- [ ] **Reward Service (8084)** — Flyway disabled. Needs Stripe API keys configured.
- [ ] **Matching Service (8087)** — Flyway disabled. Needs AWS Rekognition credentials.
- [ ] **Media Service (8085)** — No DB. Needs AWS S3 bucket + credentials.
- [ ] **Frontend-backend integration** — Wire Flutter app to running backend services.
- [ ] **Actual screens implementation** — Current frontend has scaffolding but needs real content.

### Low Priority / Nice-to-Have
- [ ] Remove Hibernate dialect warnings (PostgreSQLDialect auto-detected in modern Hibernate)
- [ ] Fix `bloc` dependency warnings (bloc not in pubspec but used in cubit files)
- [ ] Replace deprecated `withOpacity()` calls with `withValues()` throughout codebase
- [ ] Configure API Gateway route definitions for all upstream services
- [ ] Add health check dashboard showing all service statuses

### Infrastructure Notes
- Docker PostgreSQL uses port **5433** (not 5432 due to Windows service conflict)
- All services use `POSTGRES_HOST_AUTH_METHOD: trust` for dev (not for production!)
- Flyway history tables: `flyway_auth_history`, `flyway_alert_history`, `flyway_messaging_history`, `flyway_analytics_history`
- RabbitMQ management UI: http://localhost:15672 (guest/guest)
- Elasticsearch: http://localhost:9200 (security disabled for dev)

---

*Documented by Claw during 2026-06-09 session*
