# Session Log — 2026-06-10: Full System Bring-Up & Credential Wiring

> **Date:** 2026-06-10 | **Session Length:** ~3 hours  
> **Objective:** Populate `.env` with all API credentials, resolve all schema/bootstrap failures, and get the full PawFinder system (9 backend services + Flutter frontend) operational end-to-end.

---

## Outcome Summary

| Layer | Component | Port | Status |
|-------|-----------|------|--------|
| **Infrastructure** | PostgreSQL 15+PostGIS | 5433 | 🟢 Running (7h+) |
| | Redis 7.2 | 6379 | 🟢 Running |
| | RabbitMQ 3.12 | 5672 / 15672 (mgmt) | 🟢 Running |
| | Elasticsearch 8.12 | 9200 | 🟢 Running |
| **Backend** | API Gateway | 8080 | 🟢 18 routes, circuit breakers |
| | Auth Service (Twilio SMS) | 8081 | 🟢 |
| | Alert Service | 8082 | 🟢 |
| | Messaging Service | 8083 | 🟢 |
| | Reward Service (Stripe) | 8084 | 🟢 |
| | Media Service (AWS S3) | 8085 | 🟢 |
| | Analytics Service | 8086 | 🟢 |
| | Matching Service (AWS Rekog) | 8087 | 🟢 |
| | Notification Service (FCM+SendGrid) | 8088 | 🟢 |
| **Frontend** | Flutter Web (release build) | 9876 | 🟢 Served |

---

## 1. Credential Wiring — `.env` Population

### 1.1 API Keys Provisioned

| Service | Key | Environment Variable | Status |
|---------|-----|---------------------|--------|
| **Stripe** | `sk_test_51Tg...` / `pk_test_51Tg...` | `STRIPE_SECRET_KEY`, `STRIPE_PUBLISHABLE_KEY` | ✅ (corrected from `mk_` prefix keys to standard `sk_test_/pk_test_` format) |
| **AWS S3** | `AKIAQ3N4YS5EJD6M6BOU` / `cre0m7...` | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` | ✅ |
| **Firebase** | `AIzaSyA...RmiE` (from google-services.json) | `FIREBASE_SERVER_KEY`, `FIREBASE_PROJECT_ID` | ✅ |
| **Twilio** | `AC9e65...` / `c2d1e9...` / `+13367509566` | `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN`, `TWILIO_PHONE_NUMBER` | ✅ |
| **SendGrid** | `SG.Isx8...` | `SENDGRID_API_KEY` | ✅ |
| **Google Maps** | `AIzaSyA...RmiE` (from Firebase GCP project) | `GOOGLE_MAPS_API_KEY` | ✅ (goes in Flutter platform configs, noted in .env) |

### 1.2 Files Verified in `Downloads/`
- `google-services.json` — Firebase Android config (`package_name: com.pawfinder`)
- `pawfinder-57835-76382bd28e46.json` — Firebase service account key
- `pawfinder-dev_accessKeys.csv` — AWS IAM credentials
- `PawFinder_Dependencies.md` — Full Flutter + Spring Boot dependency list
- `PawFinder_Design_Guide.md` — v1.0 Design system
- `PawFinder_SDLC_Java_Flutter.md` — SDLC documentation

### 1.3 Remaining Gap
- `STRIPE_WEBHOOK_SECRET` left as `whsec_change_me` — needs Stripe CLI or dashboard webhook setup.
- Firebase FCM Server Key may need the Cloud Messaging legacy key or newer service account approach (currently using the google-services.json API key as a starting point).

---

## 2. Schema Mismatch Repairs (5 Issues Fixed)

Every service had `ddl-auto: none` (schema validation), but Hibernate scans ALL shared entities against the current DB schema. Since Flyway migrations ran on different services with separate history tables, schema gaps emerged.

### Issue 2.1: Alert Entity — Missing PostGIS Column
```
Schema-validation: missing column [last_seen_location] in table [alerts]
```
**Root cause:** Java `Alert` entity uses `@JdbcTypeCode(SqlTypes.GEOGRAPHY)` → expects `last_seen_location GEOGRAPHY(Point,4326)`. Flyway V3 created `last_seen_latitude` / `last_seen_longitude` as `DOUBLE PRECISION` instead.

**Fix:** Created **V5 migration** (`V5__add_postgis_location.sql`):
```sql
ALTER TABLE alerts ADD COLUMN IF NOT EXISTS last_seen_location GEOGRAPHY(Point, 4326);
UPDATE alerts SET last_seen_location = ST_SetSRID(ST_MakePoint(last_seen_longitude, last_seen_latitude), 4326)
WHERE last_seen_location IS NULL AND last_seen_latitude IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_alerts_location_geog ON alerts USING GIST (last_seen_location);
```

### Issue 2.2: Sighting Entity — Missing PostGIS Column
```
Schema-validation: missing column [location] in table [sightings]
```
**Root cause:** Same pattern as alerts — entity expects `GEOGRAPHY(Point,4326)`, migration created `location_latitude`/`location_longitude` doubles.

**Fix:** Created **V6 migration** (`V6__add_sighting_postgis_location.sql`) with same pattern, plus GIST spatial index.

### Issue 2.3: DailyMetrics — Missing Table
```
Schema-validation: missing table [daily_metrics]
```
**Root cause:** Analytics service owns this table via V7 migration, but the service never started (and its `pom.xml` is missing the Flyway dependency entirely).

**Fix:** Created table manually in PostgreSQL:
```sql
CREATE TABLE IF NOT EXISTS daily_metrics (
    date DATE PRIMARY KEY,
    active_alerts INT NOT NULL DEFAULT 0,
    new_alerts INT NOT NULL DEFAULT 0,
    resolved_alerts INT NOT NULL DEFAULT 0,
    avg_resolution_hours DECIMAL(10,2),
    total_rewards_offered DECIMAL(15,2),
    total_rewards_claimed DECIMAL(15,2),
    new_users INT NOT NULL DEFAULT 0,
    active_users INT NOT NULL DEFAULT 0
);
```

### Issue 2.4: Pet Entity — Column Type Mismatch (JSONB vs TEXT)
```
Schema-validation: wrong column type encountered in column [photos] in table [pets];
found [jsonb (Types#OTHER)], but expecting [text (Types#VARCHAR)]
```
**Fix:** Updated `Pet.java` entity to match the DB:
```java
// Before:
@Column(columnDefinition = "TEXT")
private String photos;

// After:
@JdbcTypeCode(SqlTypes.JSON)
@Column(columnDefinition = "JSONB")
private String photos;
```

### Issue 2.5: Sighting Entity — Column Type Mismatch (JSONB vs TEXT)
```
Schema-validation: wrong column type encountered in column [photo_urls] in table [sightings];
found [jsonb (Types#OTHER)], but expecting [text (Types#VARCHAR)]
```
**Fix:** Updated `Sighting.java` entity:
```java
@JdbcTypeCode(SqlTypes.JSON)
@Column(name = "photo_urls", columnDefinition = "JSONB")
private String photoUrls;
```

---

## 3. Service Bootstrap Failures (3 Issues Fixed)

### Issue 3.1: Media Service — Unnecessary DataSource
```
Failed to configure a DataSource: 'url' attribute is not specified
```
**Root cause:** `pawfinder-shared` brings in `spring-boot-starter-data-jpa` transitively. Media service only needs AWS S3, not a database.

**Fix:** Added autoconfig exclusions to `pawfinder-media-service/src/main/resources/application.yml`:
```yaml
spring:
  autoconfigure:
    exclude:
      - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
      - org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
```

### Issue 3.2: API Gateway — Unnecessary DataSource
Same root cause as media service. API Gateway only needs Redis for rate limiting.

**Fix:** Same autoconfig exclusions added to `pawfinder-api-gateway/src/main/resources/application.yml`.

### Issue 3.3: API Gateway — Spring MVC / WebFlux Conflict
```
Spring MVC found on classpath, which is incompatible with Spring Cloud Gateway.
```
**Root cause:** `pawfinder-shared` brings `spring-boot-starter-web` (which includes Spring MVC), but Spring Cloud Gateway requires WebFlux (reactive).

**Fix:** Added to API Gateway config:
```yaml
spring:
  main:
    web-application-type: reactive
```

---

## 4. Flutter Frontend

### 4.1 Build Process
- `flutter build web --release` compiled successfully after resolving dependencies.
- First build took ~3 minutes (Dart AOT compilation with `dartaotruntime`).

### 4.2 Serving
- Static files served via `python -m http.server 9876` from `build/web/`.
- App accessible at `http://localhost:9876` in Edge/Chrome.
- Direct `flutter run -d edge/chrome` failed due to debug service connection timeouts — release build + static serve was the reliable path.

### 4.3 Flutter Devices Available
- Windows (desktop)
- Chrome (web)
- Edge (web)

---

## 5. Current Database Schema

| Table | Owned By | Migration | Status |
|-------|----------|-----------|--------|
| `users` | Auth Service | V1 | ✅ |
| `pets` | Alert Service | V2 | ✅ |
| `alerts` | Alert Service | V3 + V5 (PostGIS) | ✅ |
| `sightings` | Alert Service | V4 + V6 (PostGIS) | ✅ |
| `conversations` | Messaging Service | V5 | ✅ |
| `messages` | Messaging Service | V6 | ✅ |
| `daily_metrics` | Analytics (manual) | — | ✅ |
| `flyway_alert_history` | Alert Service | — | ✅ |
| `flyway_auth_history` | Auth Service | — | ✅ |
| `flyway_messaging_history` | Messaging Service | — | ✅ |

---

## 6. API Gateway Routing Table

| Route ID | Path Pattern | Upstream | Circuit Breaker |
|----------|-------------|----------|----------------|
| auth-service | `/api/v1/auth/**` | localhost:8081 | ✅ + Rate Limiter |
| core-service | `/api/v1/alerts/**`, `/sightings/**`, `/pets/**` | localhost:8082 | ✅ |
| messaging-service | `/api/v1/conversations/**`, `/messages/**` | localhost:8083 | ✅ |
| reward-service | `/api/v1/rewards/**` | localhost:8084 | ✅ |
| media-service | `/api/v1/media/**` | localhost:8085 | ✅ |
| analytics-service | `/api/v1/dashboard/**`, `/leaderboard/**`, `/badges/**` | localhost:8086 | ✅ |
| websocket-service | `/ws/**` | ws://localhost:8083 | ✅ |

---

## 7. Files Modified This Session

| File | Change |
|------|--------|
| `pawfinder-app-backend/.env` | Populated all 6 API credentials |
| `pawfinder-shared/.../domain/Pet.java` | `photos` column: TEXT → JSONB + `@JdbcTypeCode` |
| `pawfinder-shared/.../domain/Sighting.java` | `photo_urls` column: TEXT → JSONB + `@JdbcTypeCode` |
| `pawfinder-alert-service/.../db/migration/V5__add_postgis_location.sql` | **NEW** — PostGIS column + index on alerts |
| `pawfinder-alert-service/.../db/migration/V6__add_sighting_postgis_location.sql` | **NEW** — PostGIS column + index on sightings |
| `pawfinder-media-service/.../application.yml` | Added DataSource + JPA autoconfig exclusions |
| `pawfinder-api-gateway/.../application.yml` | Added DataSource + JPA exclusions + `web-application-type: reactive` |
| `pawfinder-app-backend/start-all.ps1` | **NEW** — PowerShell script to launch all 9 services |

---

## 8. Remaining Backlog (Updated from 2026-06-09)

### Critical
- [ ] **Analytics Service Flyway dependency** — Add `flyway-core` + `flyway-postgresql` to `pawfinder-analytics-service/pom.xml` so V7 migration runs automatically.
- [ ] **Stripe Webhook Secret** — Set up via Stripe CLI or dashboard.
- [ ] **Firebase FCM Server Key** — Verify the google-services.json API key works for push; may need dedicated FCM key.
- [ ] **Google Maps API Key in Flutter** — Add to `AndroidManifest.xml` and `AppDelegate.swift`.

### High Priority
- [ ] **Flutter Dev Mode** — Resolve debug service connection issue so `flutter run -d edge` works (currently times out waiting for debug protocol). Release build + static serve works as a fallback.
- [ ] **Frontend-backend integration** — Point Flutter app's `api_constants.dart` to `http://localhost:8080` (API Gateway) and test auth flow.
- [ ] **Actual screen implementation** — Current Flutter app has scaffolding/theme/widgets but no real data flow.

### Medium Priority
- [ ] Remove Hibernate dialect warnings (auto-detected in Hibernate 6.4+)
- [ ] Fix `bloc` dependency warnings
- [ ] Replace deprecated `withOpacity()` → `withValues()` in Flutter codebase
- [ ] Add health check dashboard endpoint aggregating all 9 service statuses

### Completed This Session
- [x] Populate `.env` with all API keys (Stripe, AWS, Firebase, Twilio, SendGrid, Google Maps)
- [x] Fix 5 schema mismatches blocking service startup
- [x] Fix 3 service bootstrap failures (media, gateway DataSource, gateway MVC/WebFlux)
- [x] Get all 9 backend services running and healthy
- [x] Build and serve Flutter web frontend
- [x] Verify API Gateway routes all 18 endpoints with circuit breakers
- [x] Create `start-all.ps1` convenience script

---

## 9. How to Restart Everything

```powershell
# 1. Start infrastructure (if not running)
cd C:\Users\rori\Desktop\5.projects\2.java_projects\4.personal_projects\19.Paws\pawfinder-app-backend
docker compose up -d

# 2. Build all services
mvn clean package -DskipTests

# 3. Start all 9 backend services
powershell -ExecutionPolicy Bypass -File start-all.ps1
# (Note: start-all.ps1 needs fix — see note below)

# 4. Build & serve Flutter frontend
cd ..\pawfinder_app_frontend
flutter build web --release
cd build\web
python -m http.server 9876

# 5. Open in browser
# http://localhost:9876 — Flutter app
# http://localhost:8080/actuator/health — API Gateway health
# http://localhost:15672 — RabbitMQ management (guest/guest)
```

> **Note:** `start-all.ps1` has a PowerShell quirk with `RedirectStandardOutput`/`RedirectStandardError` pointing to the same file. Services were started individually via `exec` in this session. The script needs a minor fix (use separate log files or omit the redirect flags).

---

*Documented by Claw — 2026-06-10 session*
