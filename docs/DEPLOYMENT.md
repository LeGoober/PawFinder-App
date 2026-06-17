# PawFinder V0.1 — Deployment Guide

> **Status:** Draft | **Target:** Render (PaaS) | **Last Updated:** 2026-06-15

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Local Development](#local-development)
3. [Docker Build Strategy](#docker-build-strategy)
4. [Render Deployment](#render-deployment)
5. [Environment Variables](#environment-variables)
6. [CI/CD Pipeline](#cicd-pipeline)
7. [Mobile Deployment Roadmap](#mobile-deployment-roadmap)
8. [Cost Estimates](#cost-estimates)

---

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────┐
│                        Render Cloud                          │
│                                                              │
│  ┌──────────────┐   ┌──────────────────────────────────┐    │
│  │ Flutter Web  │   │         API Gateway :8080         │    │
│  │ (Static Site)│──▶│    (Spring Cloud Gateway)         │    │
│  └──────────────┘   └──────┬──────┬──────┬──────┬──────┘    │
│                             │      │      │      │           │
│                    ┌────────┘      │      │      └──────┐    │
│                    ▼               ▼      ▼             ▼    │
│              ┌──────────┐  ┌──────────┐ ┌──────────┐ ┌────┐ │
│              │  Auth     │  │  Alert   │ │Messaging │ │... │ │
│              │  :8081    │  │  :8082   │ │  :8083   │ │    │ │
│              └─────┬─────┘  └────┬─────┘ └──────────┘ └────┘ │
│                    │             │                            │
│                    ▼             ▼                            │
│              ┌──────────────────────────┐                    │
│              │   Managed PostgreSQL     │                    │
│              │   (with PostGIS)         │                    │
│              └──────────────────────────┘                    │
│                                                              │
│              ┌──────────┐  ┌──────────────┐                  │
│              │  Redis   │  │ Twilio (SMS) │                  │
│              │ (Managed)│  │  (External)  │                  │
│              └──────────┘  └──────────────┘                  │
└──────────────────────────────────────────────────────────────┘
```

### Key Design Decisions

| Concern | Local Dev | Production (Render) |
|---------|-----------|---------------------|
| PostgreSQL + PostGIS | Docker container | Render Managed DB (has PostGIS) |
| Redis | Docker container | Render Managed Redis |
| RabbitMQ | Docker container | **Skipped for V0.1** — not critical yet |
| Elasticsearch | Docker container | **Skipped for V0.1** — defer to V0.2 |
| File Storage | Local disk | AWS S3 (already configured) |
| SMS Auth | Dev mode (code: `123456`) | Twilio (live) |

### Service Consolidation for V0.1

9 microservices is overkill for an MVP. **Recommended V0.1 approach:**

1. **Deploy independently:** API Gateway, Auth Service, Alert Service
2. **Consolidate into Alert Service:** Messaging, Reward, Analytics (they're light)
3. **Defer to V0.2:** Media (S3 upload can be direct), Matching (needs Rekognition data), Notification (FCM can be client-side initially)

This gets us from 10 services to **4 services + 1 static site**, which is much more manageable on Render's free/cheap tiers.

---

## Local Development

### Prerequisites
- Docker Desktop
- Java 21
- Flutter SDK 3.24+
- PowerShell (Windows)

### 1. Start Infrastructure

```powershell
cd pawfinder-app-backend
docker compose -f docker-compose.yml up -d
```

This starts PostgreSQL+PostGIS, Redis, RabbitMQ, Elasticsearch.

### 2. Start Backend Services

```powershell
# Option A: All services together
.\start-all.ps1

# Option B: Individual service
cd pawfinder-auth-service
..\mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dserver.port=8081"
```

Services and ports:

| Service | Port | Depends On |
|---------|------|------------|
| API Gateway | 8080 | Redis (rate limiting) |
| Auth Service | 8081 | PostgreSQL, Twilio |
| Alert Service | 8082 | PostgreSQL+PostGIS |
| Messaging | 8083 | PostgreSQL |
| Reward | 8084 | PostgreSQL, Stripe |
| Media | 8085 | AWS S3 |
| Analytics | 8086 | PostgreSQL |
| Matching | 8087 | AWS Rekognition |
| Notification | 8088 | Firebase, SendGrid |

### 3. Start Flutter Web Frontend

```powershell
cd pawfinder_app_frontend
flutter pub get
flutter run -d chrome --web-port 9876
```

### 4. Test Auth Flow

1. Open `http://localhost:9876`
2. Splash → checks auth → redirects to onboarding
3. Onboarding → "Get Started" → Login page
4. Enter any phone number (e.g., `+27812345678`)
5. Dev mode sends code `123456` (check auth-service logs)
6. Enter `123456` → verified → redirected to home

---

## Docker Build Strategy

### Frontend (Flutter Web → Nginx)

```powershell
cd pawfinder_app_frontend
docker build -t pawfinder-frontend .
docker run -p 8089:80 pawfinder-frontend
```

Open `http://localhost:8089` — Nginx serves the Flutter web build with SPA fallback.

### Backend (per-service)

```powershell
cd pawfinder-app-backend

# Build and run a specific service
docker build --build-arg SERVICE_NAME=pawfinder-auth-service -t pawfinder-auth .
docker run -p 8081:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5433/pawfinder \
  -e SPRING_DATASOURCE_USERNAME=pawfinder \
  -e SPRING_DATASOURCE_PASSWORD=pawfinder_dev \
  pawfinder-auth
```

> **Note:** The backend Dockerfile accepts `SERVICE_NAME` as a build arg.  
> All services expose port 8080 internally; you map different host ports.

---

## Render Deployment

### Prerequisites

1. Push repo to GitHub (public or private)
2. Connect GitHub to Render: https://dashboard.render.com
3. Have API keys ready: Twilio, Stripe, AWS, SendGrid, Firebase

### Step-by-Step

#### 1. Deploy via Blueprint (recommended)

```powershell
# From repo root — Render auto-detects render.yaml
git add render.yaml
git commit -m "Add Render Blueprint for V0.1 deployment"
git push
```

Then in Render Dashboard:
1. **Blueprints** → **New Blueprint Instance**
2. Connect your GitHub repo
3. Render reads `render.yaml` and creates all services
4. Set secret env vars: Twilio, Stripe, AWS, etc. (marked `sync: false`)
5. Deploy

#### 2. Manual Deployment (if not using Blueprint)

**Frontend (Static Site):**
1. Render Dashboard → New → Static Site
2. Connect repo, set:
   - **Root Directory:** `pawfinder_app_frontend`
   - **Build Command:** `flutter build web --release`
   - **Publish Directory:** `build/web`
   - **Rewrite Rule:** `/* → /index.html`

**API Gateway (Web Service):**
1. Render Dashboard → New → Web Service
2. Connect repo, set:
   - **Root Directory:** `pawfinder-app-backend`
   - **Docker Build Command:** `docker build --build-arg SERVICE_NAME=pawfinder-api-gateway -t gateway .`
3. Add env vars (see below)
4. Set health check to `/actuator/health`

**Repeat for each backend service.**

#### 3. Managed Database (PostgreSQL + PostGIS)

Render's managed PostgreSQL supports the PostGIS extension:
1. Dashboard → New → PostgreSQL
2. After creation, enable PostGIS:
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   ```
3. Connection string auto-injected as `DATABASE_URL` env var

#### 4. Frontend Environment Configuration

The Flutter web app needs to know the API Gateway URL. For Render:

```dart
// lib/core/constants/api_constants.dart
static String get baseUrl {
  // In production, point to Render API Gateway URL
  const renderUrl = String.fromEnvironment('API_BASE_URL');
  if (renderUrl.isNotEmpty) return renderUrl;
  
  // Fallback for local dev
  return 'http://localhost:8080';
}
```

Then in Render, set the build command:
```
flutter build web --release --dart-define=API_BASE_URL=https://pawfinder-api-gateway.onrender.com
```

---

## Environment Variables

### Required for V0.1 Deployment

| Variable | Service | Source |
|----------|---------|--------|
| `SPRING_DATASOURCE_URL` | All backend | Render Managed DB |
| `SPRING_DATASOURCE_USERNAME` | All backend | Render Managed DB |
| `SPRING_DATASOURCE_PASSWORD` | All backend | Render Managed DB |
| `SPRING_REDIS_HOST` | API Gateway | Render Managed Redis |
| `SPRING_REDIS_PORT` | API Gateway | Render Managed Redis |
| `JWT_SECRET` | Auth, Gateway | Generate (64+ chars) |
| `TWILIO_ACCOUNT_SID` | Auth | Twilio Console |
| `TWILIO_AUTH_TOKEN` | Auth | Twilio Console |
| `TWILIO_PHONE_NUMBER` | Auth | Twilio Console |
| `STRIPE_SECRET_KEY` | Reward | Stripe Dashboard |
| `STRIPE_WEBHOOK_SECRET` | Reward | Stripe Dashboard |
| `AWS_ACCESS_KEY_ID` | Media, Matching | AWS IAM |
| `AWS_SECRET_ACCESS_KEY` | Media, Matching | AWS IAM |
| `AWS_S3_BUCKET` | Media | AWS S3 |
| `FIREBASE_SERVER_KEY` | Notification | Firebase Console |
| `SENDGRID_API_KEY` | Notification | SendGrid |

### Setting Secrets in Render

Env vars marked `sync: false` in `render.yaml` must be set manually:
1. Dashboard → Service → Environment
2. Add each variable with its value
3. Redeploy

---

## CI/CD Pipeline

### Recommended: GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy PawFinder V0.1

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  # ── Backend ──────────────────────────────────
  backend-test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgis/postgis:15-3.4
        env:
          POSTGRES_DB: pawfinder_test
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports:
          - 5432:5432
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: 21
          distribution: temurin
      - name: Run tests
        run: cd pawfinder-app-backend && mvn test
        env:
          SPRING_DATASOURCE_URL: jdbc:postgresql://localhost:5432/pawfinder_test
          SPRING_DATASOURCE_USERNAME: test
          SPRING_DATASOURCE_PASSWORD: test

  # ── Frontend ─────────────────────────────────
  frontend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - name: Analyze
        run: cd pawfinder_app_frontend && flutter analyze
      - name: Build web
        run: cd pawfinder_app_frontend && flutter build web --release

  # ── Deploy to Render ─────────────────────────
  deploy:
    needs: [backend-test, frontend-test]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Render Deploy
        run: |
          curl -X POST https://api.render.com/deploy/${{ secrets.RENDER_SERVICE_ID }}?key=${{ secrets.RENDER_API_KEY }}
```

### for Mobile CI/CD (Future)

Add to the workflow for V0.2+:

```yaml
  android-build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: 17
          distribution: temurin
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - name: Build APK
        run: cd pawfinder_app_frontend && flutter build apk --release
      - name: Build App Bundle
        run: cd pawfinder_app_frontend && flutter build appbundle --release
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_STORE_SA }}
          packageName: com.pawfinder.app
          releaseFiles: pawfinder_app_frontend/build/app/outputs/bundle/release/app-release.aab

  ios-build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - name: Build iOS
        run: |
          cd pawfinder_app_frontend
          flutter build ios --release --no-codesign
      - name: Upload to App Store
        uses: appleboy/upload-testflight-action@v1
        # ... TestFlight upload config
```

---

## Mobile Deployment Roadmap

### Android (Google Play Store)

| Step | Action | Complexity |
|------|--------|------------|
| 1 | Generate keystore (`keytool -genkey`) | Low |
| 2 | Create `key.properties` | Low |
| 3 | Configure `build.gradle` for signing | Low |
| 4 | Build release: `flutter build appbundle` | Low |
| 5 | Create Play Console account ($25 one-time) | Low |
| 6 | Upload `.aab` to Play Console | Low |
| 7 | Set up internal testing track | Low |
| 8 | Release to production | Low |

**From Windows:** Fully supported — Android builds work natively on Windows.

### iOS (Apple App Store)

| Step | Action | Complexity |
|------|--------|------------|
| 1 | Apple Developer account ($99/year) | Low (but annual cost) |
| 2 | **Acquire macOS machine** (or cloud Mac) | **HIGH** — cannot build iOS on Windows |
| 3 | Configure Xcode project | Medium |
| 4 | Set up code signing + provisioning profiles | Medium-High |
| 5 | Build release: `flutter build ipa` | Medium |
| 6 | Upload via Transporter/Xcode | Medium |
| 7 | App Store review process | Medium (1-3 days) |

**The Windows Problem:** iOS builds require Xcode, which only runs on macOS. Your options:
1. **Mac Mini** (~$600) — cheapest permanent solution
2. **MacStadium / MacInCloud** (~$20-40/month) — cloud Mac for CI only
3. **GitHub Actions macOS runner** — $0.08/min, good for occasional builds
4. **Codemagic** — free tier includes macOS builders for Flutter

**Recommended for V0.2:** Use Codemagic (free tier, 500 min/month) for iOS CI/CD. It handles code signing and App Store Connect upload automatically.

### Pre-Flight Checklist (Before Submitting to Any Store)

- [ ] Privacy policy URL (required for both stores)
- [ ] Terms of service (recommended)
- [ ] App icon (1024x1024 for stores, generated from Flutter icon)
- [ ] Screenshots (at least 2, 3 recommended per device size)
- [ ] Feature graphic (Play Store, 1024x500)
- [ ] App description + short description
- [ ] Content rating questionnaire
- [ ] Target SDK 34+ (required by Play Store from Aug 2024)
- [ ] Data safety section (Play Store)
- [ ] App privacy details (App Store)

---

## Cost Estimates

### Render (V0.1 — 4 services + static site + DB + Redis)

| Resource | Plan | Monthly |
|----------|------|---------|
| Frontend (Static Site) | Free | $0 |
| API Gateway (Web Service) | Starter ($7) | $7 |
| Auth Service (Web Service) | Starter ($7) | $7 |
| Alert Service (Web Service) | Starter ($7) | $7 |
| 4 consolidated services | Starter ($7 each) | $28 |
| PostgreSQL (Managed) | Starter ($7) | $7 |
| Redis (Managed) | Free | $0 |
| **Total** | | **$56/month** |

### With Consolidation (V0.1 lean — 3 services)

| Resource | Plan | Monthly |
|----------|------|---------|
| Frontend (Static Site) | Free | $0 |
| API Gateway | Starter ($7) | $7 |
| Auth Service | Starter ($7) | $7 |
| Alert + consolidated services | Starter ($7) | $7 |
| PostgreSQL | Starter ($7) | $7 |
| Redis | Free | $0 |
| **Total** | | **$28/month** |

### Deferred to V0.2 (when needed)

- RabbitMQ (CloudAMQP): ~$0-5/month free tier
- Elasticsearch (Elastic Cloud): ~$16/month
- Render Individual tier: $19/service/month (more RAM, no cold starts)

---

## Summary: V0.1 Deployment Checklist

### Immediate (this sprint)
- [ ] Fix `API_BASE_URL` in Flutter to accept environment variable
- [ ] Create production Spring profile (`application-prod.yml`)
- [ ] Create `.github/workflows/deploy.yml`
- [ ] Push to GitHub
- [ ] Set up Render Blueprint
- [ ] Configure all secret env vars in Render
- [ ] Run Flyway migrations on production DB
- [ ] Test full auth flow on production
- [ ] Set up custom domain (optional)

### Next Sprint (V0.2)
- [ ] Android build + Play Store internal testing
- [ ] Codemagic setup for iOS CI/CD
- [ ] Feature: map view with real Google Maps
- [ ] Feature: push notifications (FCM)
- [ ] Integration tests
- [ ] RabbitMQ for async alert matching
