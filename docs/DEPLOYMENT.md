# PawFinder V0.1 — Deployment Guide

> **Status:** 🟢 Deploy-Ready | **Target:** Render (PaaS) | **Last Updated:** 2026-06-19
>
> **Current state:** `main` branch has functional prototype. Dockerfiles ready. CI/CD active.
> **Payment needed:** Render requires a card on file even for free tiers.

---

## Table of Contents

1. [Deployment Options — Pick Your Path](#deployment-options--pick-your-path)
2. [Path B: Manual Deployment (Recommended)](#path-b-manual-deployment-recommended)
3. [Path A: Blueprint One-Click](#path-a-blueprint-one-click)
4. [Path C: Free Tier Hacks](#path-c-free-tier-hacks)
5. [Environment Variables Reference](#environment-variables-reference)
6. [Post-Deploy Verification](#post-deploy-verification)
7. [Local Development](#local-development)
8. [CI/CD Pipeline](#cicd-pipeline)
9. [Mobile Deployment Roadmap](#mobile-deployment-roadmap)
10. [Cost Estimates](#cost-estimates)

---

## Deployment Options — Pick Your Path

| Path | Frontend | Backend | DB + Redis | Monthly | Effort |
|------|----------|---------|------------|---------|--------|
| **A** Blueprint | Docker ($7) | 10 services ($70) | Managed ($7) | ~$77 | 5 min |
| **B** Manual ✨ | Docker ($7) | 3 services ($21) | Managed ($7) | ~$35 | 20 min |
| **C** Free tier | GitHub Pages ($0) | 1 service ($7) | Neon + Upstash ($0) | ~$7 | 45 min |

> **Recommendation: Path B.** Reasonable cost, moderate effort, real infrastructure.

### Prerequisite for All Paths
Add a payment method to Render: https://dashboard.render.com → Account → Billing.
You're only charged for Starter-plan services actually running. Static sites and free-tier Redis cost nothing.

---

## Path B: Manual Deployment (Recommended)

**Goal:** 5 Render resources — Frontend, API Gateway, Auth+Core, DB, Redis.
**Cost:** ~$35/month | **Time:** 20 minutes.

### Step 1: Create PostgreSQL Database (Free to create, $7/mo to run)

1. Render Dashboard → **New** → **PostgreSQL**
2. Configure:
   - **Name:** `pawfinder-db`
   - **Database:** `pawfinder`
   - **User:** `pawfinder`
   - **Plan:** Starter ($7/mo)
   - **IP Allow List:** leave empty (internal access only)
3. Click **Create Database**
4. After creation → **Shell** tab → run:
   ```sql
   CREATE EXTENSION IF NOT EXISTS postgis;
   SELECT PostGIS_Version();  -- verify it returns a version
   ```
5. Copy the **Internal Database URL** — you'll need it for backend env vars.
   Format: `postgres://pawfinder:<password>@<host>:5432/pawfinder`

### Step 2: Create Redis (Free)

1. Render Dashboard → **New** → **Redis**
2. Configure:
   - **Name:** `pawfinder-redis`
   - **Plan:** Free
3. Click **Create Redis**
4. Copy the **Internal Redis URL** — format: `redis://<host>:<port>`

### Step 3: Deploy Frontend (Flutter Web → Docker)

1. Render Dashboard → **New** → **Web Service**
2. Connect repo: `LeGoober/PawFinder-App`
3. Configure:
   - **Name:** `pawfinder-frontend`
   - **Root Directory:** `pawfinder_app_frontend`
   - **Runtime:** Docker
   - **Plan:** Starter ($7/mo)
   - **Health Check Path:** `/`
4. **Environment Variables** tab — add:
   | Key | Value |
   |-----|-------|
   | `API_BASE_URL` | `https://pawfinder-api-gateway.onrender.com` |

   > ⚠️ Wait until after Step 4 to set this — you need the API Gateway URL first. Leave blank for now, come back after the gateway is deployed.

5. Click **Create Web Service** — Render builds the Dockerfile (Flutter build → Nginx).

### Step 4: Deploy API Gateway

1. Render Dashboard → **New** → **Web Service**
2. Connect repo: `LeGoober/PawFinder-App`
3. Configure:
   - **Name:** `pawfinder-api-gateway`
   - **Root Directory:** `pawfinder-app-backend`
   - **Runtime:** Docker
   - **Docker Build Command:** `docker build --build-arg SERVICE_NAME=pawfinder-api-gateway -t gateway .`
   - **Plan:** Starter ($7/mo)
   - **Health Check Path:** `/actuator/health`
4. **Environment Variables** tab — add:
   | Key | Value |
   |-----|-------|
   | `SPRING_PROFILES_ACTIVE` | `prod` |
   | `SPRING_DATASOURCE_URL` | `jdbc:postgresql://<DB_HOST>:5432/pawfinder` |
   | `SPRING_DATASOURCE_USERNAME` | `pawfinder` |
   | `SPRING_DATASOURCE_PASSWORD` | `<DB_PASSWORD>` |
   | `SPRING_REDIS_HOST` | `<REDIS_HOST>` |
   | `SPRING_REDIS_PORT` | `<REDIS_PORT>` |
   | `AUTH_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `ALERT_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `MESSAGING_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `REWARD_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `MEDIA_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `ANALYTICS_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `MATCHING_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `NOTIFICATION_SERVICE_URL` | `http://pawfinder-auth-service:8080` |
   | `JWT_SECRET` | `openssl rand -hex 32` (generate locally and paste) |

   > **Consolidation note:** All backend service URLs point to `pawfinder-auth-service` because we're running all backend logic in a single service to save money. The auth service will run with all Spring profiles active.

5. Click **Create Web Service**.

### Step 5: Deploy Auth+Consolidated Service

1. Render Dashboard → **New** → **Web Service**
2. Connect repo: `LeGoober/PawFinder-App`
3. Configure:
   - **Name:** `pawfinder-auth-service`
   - **Root Directory:** `pawfinder-app-backend`
   - **Runtime:** Docker
   - **Docker Build Command:** `docker build --build-arg SERVICE_NAME=pawfinder-auth-service -t auth .`
   - **Plan:** Starter ($7/mo)
   - **Health Check Path:** `/actuator/health`
4. **Environment Variables** tab — add:

   **Database:**
   | Key | Value |
   |-----|-------|
   | `SPRING_PROFILES_ACTIVE` | `prod` |
   | `SPRING_DATASOURCE_URL` | `jdbc:postgresql://<DB_HOST>:5432/pawfinder` |
   | `SPRING_DATASOURCE_USERNAME` | `pawfinder` |
   | `SPRING_DATASOURCE_PASSWORD` | `<DB_PASSWORD>` |

   **Auth:**
   | Key | Value |
   |-----|-------|
   | `JWT_SECRET` | `<same as gateway>` |
   | `TWILIO_ACCOUNT_SID` | `<your Twilio Account SID from console>` |
   | `TWILIO_AUTH_TOKEN` | `<your Twilio Auth Token from console>` |
   | `TWILIO_PHONE_NUMBER` | `<your Twilio phone number>` |

   **Reward (if using Stripe):**
   | Key | Value |
   |-----|-------|
   | `STRIPE_SECRET_KEY` | `<your Stripe test secret key>` |
   | `STRIPE_WEBHOOK_SECRET` | `whsec_...` |

   **Media (if using S3):**
   | Key | Value |
   |-----|-------|
   | `AWS_ACCESS_KEY_ID` | `<your AWS Access Key ID>` |
   | `AWS_SECRET_ACCESS_KEY` | `<your AWS Secret Access Key>` |
   | `AWS_S3_BUCKET` | `pawfinder-media-dev` |
   | `AWS_REGION` | `us-east-1` |

   **Matching (if using Rekognition):**
   | Key | Value |
   |-----|-------|
   | `AWS_ACCESS_KEY_ID` | `<same as media>` |
   | `AWS_SECRET_ACCESS_KEY` | `<same as media>` |
   | `AWS_REKOGNITION_REGION` | `us-east-1` |

   **Notification (if using FCM + SendGrid):**
   | Key | Value |
   |-----|-------|
   | `FIREBASE_SERVER_KEY` | `<your Firebase server key>` |
   | `FIREBASE_PROJECT_ID` | `<your Firebase project ID>` |
   | `SENDGRID_API_KEY` | `<your SendGrid API key>` |

5. Click **Create Web Service**.

### Step 6: Wire Frontend → API Gateway

1. Go back to `pawfinder-frontend` → **Environment** tab
2. Add `API_BASE_URL` = `https://pawfinder-api-gateway.onrender.com`
3. Click **Save Changes** — triggers redeploy.

### Step 7: Google OAuth Setup

1. Google Cloud Console → APIs & Services → Credentials
2. Edit your OAuth 2.0 Client ID
3. Add to **Authorized JavaScript origins:**
   ```
   https://pawfinder-frontend.onrender.com
   ```
4. Add to **Authorized redirect URIs:**
   ```
   https://pawfinder-frontend.onrender.com
   ```
5. Enable **People API** if not already done.
6. Update the Client ID in `pawfinder_app_frontend/web/index.html` if it was a placeholder — then push to trigger redeploy.

### Step 8: Stripe Webhook (if using rewards)

1. Stripe Dashboard → Developers → Webhooks → Add endpoint
2. URL: `https://pawfinder-auth-service.onrender.com/api/v1/rewards/webhook`
3. Events: `payment_intent.succeeded`, `checkout.session.completed`
4. Copy signing secret → update `STRIPE_WEBHOOK_SECRET` in Render env vars.

### Step 9: Verify

See [Post-Deploy Verification](#post-deploy-verification) section.

### Done — 5 Resources on Render

| Resource | Type | Plan | Monthly |
|----------|------|------|---------|
| `pawfinder-frontend` | Web Service (Docker) | Starter | $7 |
| `pawfinder-api-gateway` | Web Service (Docker) | Starter | $7 |
| `pawfinder-auth-service` | Web Service (Docker) | Starter | $7 |
| `pawfinder-db` | PostgreSQL | Starter | $7 |
| `pawfinder-redis` | Redis | Free | $0 |
| **Total** | | | **$28/month** |

---

## Path A: Blueprint One-Click

If you're okay with full infrastructure from day one:

1. Add payment method to Render
2. Render Dashboard → **Blueprints** → **New Blueprint Instance**
3. Connect `LeGoober/PawFinder-App`
4. Render reads `render.yaml` and creates all 12 resources
5. Set `sync: false` env vars manually (Twilio, Stripe, AWS, etc.)
6. Enable PostGIS on `pawfinder-db`

**Cost:** ~$77/month (10 services × $7 + DB × $7)

---

## Path C: Free Tier Hacks

Maximum cheapness for testing:

| Resource | Provider | Cost |
|----------|----------|------|
| Frontend | GitHub Pages (Build Flutter in CI → deploy to `gh-pages` branch) | $0 |
| Backend | Render Web Service (1 consolidated service) | $7 |
| Database | Neon (free Postgres with PostGIS) | $0 |
| Redis | Upstash (free Redis) | $0 |
| **Total** | | **$7/month** |

Steps:
1. **GitHub Pages:** Modify CI to build Flutter web and deploy to GitHub Pages
2. **Neon DB:** Create project → enable PostGIS extension → copy connection string
3. **Upstash Redis:** Create database → copy connection URL
4. **Render:** Single Docker web service with all env vars pointing to Neon + Upstash

> Not recommended for production — cold starts on Neon, latency between providers. But works for V0.1 testing.

---

## Environment Variables Reference

### Auto-Generated / Managed
These come from your Render DB/Redis resources:

| Variable | Source | Example Format |
|----------|--------|---------------|
| `SPRING_DATASOURCE_URL` | Render PostgreSQL | `jdbc:postgresql://host:5432/pawfinder` |
| `SPRING_DATASOURCE_USERNAME` | Render PostgreSQL | `pawfinder` |
| `SPRING_DATASOURCE_PASSWORD` | Render PostgreSQL | (from Render dashboard) |
| `SPRING_REDIS_HOST` | Render Redis | `red-xxxxx.internal` |
| `SPRING_REDIS_PORT` | Render Redis | `6379` |
| `REDIS_URL` | Render Redis | `redis://host:6379` |

### Manual — API Keys (must provide yourself)

| Variable | Service | Where to Get |
|----------|---------|-------------|
| `TWILIO_ACCOUNT_SID` | Auth | Twilio Console |
| `TWILIO_AUTH_TOKEN` | Auth | Twilio Console |
| `TWILIO_PHONE_NUMBER` | Auth | Twilio Console |
| `STRIPE_SECRET_KEY` | Reward | Stripe Dashboard (test: `sk_test_...`) |
| `STRIPE_WEBHOOK_SECRET` | Reward | Stripe → Webhooks |
| `AWS_ACCESS_KEY_ID` | Media, Matching | AWS IAM |
| `AWS_SECRET_ACCESS_KEY` | Media, Matching | AWS IAM |
| `AWS_S3_BUCKET` | Media | AWS S3 |
| `FIREBASE_SERVER_KEY` | Notification | Firebase → Cloud Messaging |
| `SENDGRID_API_KEY` | Notification | SendGrid → API Keys |
| `JWT_SECRET` | All services | Generate: `openssl rand -hex 32` |

> **JWT_SECRET must be identical** across API Gateway and all backend services.

---

## Post-Deploy Verification

### 1. Health Checks

```powershell
# Frontend
curl -sI https://pawfinder-frontend.onrender.com
# Expected: HTTP/1.1 200 OK

# API Gateway
curl https://pawfinder-api-gateway.onrender.com/actuator/health
# Expected: {"status":"UP"}

# Auth
curl https://pawfinder-auth-service.onrender.com/actuator/health
# Expected: {"status":"UP"}
```

### 2. Test Auth Flow

1. Open `https://pawfinder-frontend.onrender.com`
2. Splash → Onboarding → Login page (should load without errors)
3. Enter phone number → receive SMS (Twilio in prod) → enter code → Dashboard

### 3. Verify Database

```powershell
# From Render Shell or psql
psql <DATABASE_URL>
SELECT * FROM flyway_schema_history;  -- migrations ran
\d users                              -- users table exists
SELECT PostGIS_Version();             -- PostGIS enabled
```

### 4. Test Key Pages

Navigate through: Dashboard → Alerts → Create Alert → Messaging → Profile.
Each page should load data from the API without console errors.

### Common Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| Frontend blank page | `API_BASE_URL` not set | Add to Render env vars, redeploy |
| Frontend CORS errors | Gateway not allowing Render domain | Add frontend URL to gateway CORS config |
| Auth 500 | PostGIS not enabled | `CREATE EXTENSION postgis;` on DB |
| Auth 403 | People API disabled | Google Cloud Console → enable |
| Backend won't start | `SERVICE_NAME` build arg wrong | Check Dockerfile build command |
| Build fails: flutter not found | Runtime is `static` not `docker` | Use Docker runtime for frontend |

---

## Local Development

### Prerequisites
- Docker Desktop, Java 21, Flutter SDK 3.24+

### Start Everything

```powershell
# Infrastructure
cd pawfinder-app-backend
docker compose -f docker-compose.yml up -d

# Backend
.\start-all.ps1

# Frontend
cd pawfinder_app_frontend
flutter pub get
flutter run -d chrome --web-port 9876
```

### Docker Builds

```powershell
# Frontend
cd pawfinder_app_frontend
docker build -t pawfinder-frontend .
docker run -p 8089:80 pawfinder-frontend
# Open http://localhost:8089

# Backend (per-service)
cd pawfinder-app-backend
docker build --build-arg SERVICE_NAME=pawfinder-auth-service -t pawfinder-auth .
docker run -p 8081:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5433/pawfinder \
  pawfinder-auth
```

---

## CI/CD Pipeline

`.github/workflows/deploy.yml` — triggers on push to `main`:

```
push to main
    ├── Backend: Maven test (PostgreSQL + Redis service containers)
    ├── Frontend: Flutter analyze + build web + upload artifact
    └── Deploy: Trigger Render deploy hook
              (needs RENDER_DEPLOY_HOOK_URL GitHub secret)
```

### Setting the Deploy Hook

1. Render Dashboard → any service → Settings → **Deploy Hook** → copy URL
2. GitHub → Repo Settings → Secrets → Actions → New:
   - Name: `RENDER_DEPLOY_HOOK_URL`
   - Value: the copied URL

---

## Mobile Deployment Roadmap

### Android (Google Play)
- Generate keystore → configure `build.gradle` → `flutter build appbundle`
- Play Console account ($25 one-time)
- Upload `.aab` → internal testing → production

**From Windows:** ✅ Fully supported.

### iOS (Apple App Store)
- Requires macOS — cannot build on Windows
- Options: Codemagic (free tier, 500 min/month), GitHub Actions macOS runner, Mac Mini
- Apple Developer account: $99/year

---

## Cost Estimates

### Path B — Recommended ($28/mo)

| Resource | Monthly |
|----------|---------|
| Frontend (Docker) | $7 |
| API Gateway | $7 |
| Auth+Consolidated | $7 |
| PostgreSQL | $7 |
| Redis | $0 |
| **Total** | **$28** |

### Path A — Full Blueprint ($77/mo)

| Resource | Monthly |
|----------|---------|
| 10 Docker services | $70 |
| PostgreSQL | $7 |
| Redis | $0 |
| **Total** | **$77** |

### Path C — Free Tier ($7/mo)

| Resource | Monthly |
|----------|---------|
| GitHub Pages | $0 |
| Render Web Service | $7 |
| Neon Postgres | $0 |
| Upstash Redis | $0 |
| **Total** | **$7** |

### Future V0.2 Additions
- RabbitMQ (CloudAMQP free): $0
- Elasticsearch (Elastic Cloud): ~$16/mo
- Render Individual tier: $19/service/mo (no cold starts, more RAM)

---

## Deployment Checklist

### Already Done
- [x] Code on `main` branch (GitHub: `LeGoober/PawFinder-App`)
- [x] Dockerfiles for frontend + backend
- [x] `render.yaml` Blueprint
- [x] `.github/workflows/deploy.yml` CI/CD
- [x] Secrets stripped from git history
- [x] `docs/GOOGLE_AUTH_SETUP.md`
- [x] `docs/RENDER_ENV_VARS.txt` (env var reference with placeholders)

### To Do (Pick Your Path)
- [ ] Add payment method to Render
- [ ] Create DB + Redis + Frontend + Gateway + Auth (Path B)
- [ ] Enable PostGIS on DB
- [ ] Set all env vars (JWT_SECRET, Twilio, Stripe, etc.)
- [ ] Configure Google OAuth origins/redirects
- [ ] Set Stripe webhook (if using rewards)
- [ ] Set `RENDER_DEPLOY_HOOK_URL` GitHub secret
- [ ] Verify all services healthy
- [ ] Test full auth flow
