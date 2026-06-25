# PawFinder V0.1 — Deployment Guide

> **Status:** 🟢 Deploy-Ready | **Target:** Render (PaaS) | **Last Updated:** 2026-06-24
>
> **Current state:** `main` branch has functional prototype. Per-service Dockerfiles ready. CI/CD active.
> **Payment needed:** Render requires a card on file even for free tiers.

---

## Table of Contents

1. [Deployment Options — Pick Your Path](#deployment-options--pick-your-path)
2. [Path D: Render API/CLI (Most Control) ✨](#path-d-render-apicli-most-control-)
3. [Path B: Manual Dashboard Deployment](#path-b-manual-dashboard-deployment)
4. [Path A: Blueprint One-Click (render.yaml)](#path-a-blueprint-one-click-renderyaml)
5. [Path C: Free Tier Hacks](#path-c-free-tier-hacks)
6. [Per-Service Container Deployment Reference](#per-service-container-deployment-reference)
7. [Environment Variables Reference](#environment-variables-reference)
8. [Post-Deploy Verification](#post-deploy-verification)
9. [Local Development](#local-development)
10. [CI/CD Pipeline](#cicd-pipeline)
11. [Mobile Deployment Roadmap](#mobile-deployment-roadmap)
12. [Troubleshooting Blueprint & Deploy Failures](#troubleshooting-blueprint--deploy-failures)
13. [Cost Estimates](#cost-estimates)
14. [Deployment Checklist](#deployment-checklist)

---

## Deployment Options — Pick Your Path

| Path | Frontend | Backend | DB + Redis | Monthly | Effort |
|------|----------|---------|------------|---------|--------|
| **D** CLI/API ✨ | Docker ($7) | 3-9 services ($21-63) | Managed ($7) | ~$35-77 | 30 min |
| **B** Manual | Docker ($7) | 3 services ($21) | Managed ($7) | ~$35 | 20 min |
| **A** Blueprint | Docker ($7) | 10 services ($70) | Managed ($7) | ~$77 | 5 min |
| **C** Free tier | GitHub Pages ($0) | 1 service ($7) | Neon + Upstash ($0) | ~$7 | 45 min |

> **Recommendation: Path D (CLI/API).** Gives you per-service control, deploy hooks, env var management, and works around Blueprint limitations. Use Path B if you prefer clicking through the dashboard.

### Prerequisite for All Paths

1. **Add payment to Render:** https://dashboard.render.com → Account → Billing.
   You're only charged for Starter-plan services actually running. Static sites and free-tier Redis cost nothing.
2. **Push latest to GitHub:** All Dockerfiles and `render.yaml` must be on `main`:
   ```powershell
   git push origin main
   ```
3. **Generate JWT secret:**
   ```powershell
   openssl rand -hex 32
   ```
   Save this — you'll paste it into every service.
4. **Create Render API key** (for Path D only): Render Dashboard → Account Settings → API Keys → Create Key
   Save as `RENDER_API_KEY` environment variable locally:
   ```powershell
   $env:RENDER_API_KEY = "rnd_..."
   ```

---

## Path D: Render API/CLI (Most Control) ✨

**Goal:** Deploy any set of services using the Render REST API — full programmatic control.
**Cost:** Variable ($28-77/month depending on service count) | **Time:** 30 minutes first time, 2 min for updates.

### Why CLI/API?

- Per-service control: deploy each container independently
- Scriptable: rebuild and redeploy one service without touching others
- Works around Render Blueprint limitations (build args, monorepo Dockerfile issues)
- Manage env vars, deploy hooks, and health checks programmatically
- Pair with GitHub Actions for true CI/CD

### Architecture

```
Render API (api.render.com/v1)
    ├── pawfinder-frontend       (Dockerfile in pawfinder_app_frontend/)
    ├── pawfinder-api-gateway    (Dockerfile.api-gateway)
    ├── pawfinder-auth-service   (Dockerfile.auth-service)
    ├── pawfinder-alert-service  (Dockerfile.alert-service)
    ├── pawfinder-messaging-service (Dockerfile.messaging-service)
    ├── pawfinder-reward-service    (Dockerfile.reward-service)
    ├── pawfinder-media-service     (Dockerfile.media-service)
    ├── pawfinder-analytics-service (Dockerfile.analytics-service)
    ├── pawfinder-matching-service  (Dockerfile.matching-service)
    ├── pawfinder-notification-service (Dockerfile.notification-service)
    ├── pawfinder-db             (PostgreSQL managed)
    └── pawfinder-redis          (Redis managed)
```

### Step D1: Create API Key & Set Up Environment

```powershell
# Render Dashboard → Account Settings → API Keys → Create API Key
# Copy the key, then:
$env:RENDER_API_KEY = "rnd_your_api_key_here"
$env:RENDER_OWNER_ID = "tea_..."  # From: curl -sH "Authorization: Bearer $env:RENDER_API_KEY" https://api.render.com/v1/owners | jq

# Save permanently (PowerShell profile):
Add-Content $PROFILE "`$env:RENDER_API_KEY = 'rnd_...'"
Add-Content $PROFILE "`$env:RENDER_OWNER_ID = 'tea_...'"
```

### Step D2: Create PostgreSQL Database

```powershell
curl -s -X POST "https://api.render.com/v1/postgres" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "ownerId": "'$env:RENDER_OWNER_ID'",
    "name": "pawfinder-db",
    "databaseName": "pawfinder",
    "databaseUser": "pawfinder",
    "plan": "starter",
    "region": "oregon",
    "ipAllowList": []
  }'
```

After creation, enable PostGIS via Render Dashboard → `pawfinder-db` → Shell:
```sql
CREATE EXTENSION IF NOT EXISTS postgis;
SELECT PostGIS_Version();
```

Save the DB connection info — you'll need it for env vars:
```powershell
curl -s "https://api.render.com/v1/postgres?name=pawfinder-db" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" | jq
# Note: host, port, and password from the response
```

### Step D3: Create Redis

```powershell
curl -s -X POST "https://api.render.com/v1/redis" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "ownerId": "'$env:RENDER_OWNER_ID'",
    "name": "pawfinder-redis",
    "plan": "free",
    "region": "oregon",
    "ipAllowList": []
  }'
```

### Step D4: Deploy Frontend via API

```powershell
curl -s -X POST "https://api.render.com/v1/services" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "ownerId": "'$env:RENDER_OWNER_ID'",
    "type": "web_service",
    "name": "pawfinder-frontend",
    "repo": "github.com/LeGoober/PawFinder-App",
    "branch": "main",
    "runtime": "docker",
    "rootDir": "pawfinder_app_frontend",
    "dockerfilePath": "Dockerfile",
    "plan": "starter",
    "region": "oregon",
    "healthCheckPath": "/",
    "envVars": [
      {"key": "API_BASE_URL", "value": "https://pawfinder-api-gateway.onrender.com"}
    ],
    "autoDeploy": "yes"
  }'
```

> **Note:** You can't set the `API_BASE_URL` until the API Gateway exists. Leave it blank, then update after Step D5.

### Step D5: Deploy Backend Services via API

Each backend service uses its **own per-service Dockerfile**. These are already committed to the repo:

| Service | Dockerfile | Key Env Vars |
|---------|-----------|-------------|
| `api-gateway` | `Dockerfile.api-gateway` | Service URLs, JWT, Redis |
| `auth-service` | `Dockerfile.auth-service` | DB, JWT, Twilio |
| `alert-service` | `Dockerfile.alert-service` | DB, JWT, Redis |
| `messaging-service` | `Dockerfile.messaging-service` | DB, JWT |
| `reward-service` | `Dockerfile.reward-service` | DB, JWT, Stripe |
| `media-service` | `Dockerfile.media-service` | AWS S3, JWT |
| `analytics-service` | `Dockerfile.analytics-service` | DB, JWT |
| `matching-service` | `Dockerfile.matching-service` | AWS Rekognition, JWT |
| `notification-service` | `Dockerfile.notification-service` | Firebase, SendGrid, JWT |

#### Deploy API Gateway First

```powershell
$DB_URL = "postgres://pawfinder:DB_PASSWORD@DB_HOST:5432/pawfinder"
$REDIS_URL = "redis://REDIS_HOST:REDIS_PORT"
$JWT_SECRET = "$(openssl rand -hex 32)"

curl -s -X POST "https://api.render.com/v1/services" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "ownerId": "'$env:RENDER_OWNER_ID'",
    "type": "web_service",
    "name": "pawfinder-api-gateway",
    "repo": "github.com/LeGoober/PawFinder-App",
    "branch": "main",
    "runtime": "docker",
    "rootDir": "pawfinder-app-backend",
    "dockerfilePath": "Dockerfile.api-gateway",
    "plan": "starter",
    "region": "oregon",
    "healthCheckPath": "/actuator/health",
    "envVars": [
      {"key": "SPRING_PROFILES_ACTIVE", "value": "prod"},
      {"key": "SPRING_DATASOURCE_URL", "value": "jdbc:postgresql://DB_HOST:5432/pawfinder"},
      {"key": "SPRING_DATASOURCE_USERNAME", "value": "pawfinder"},
      {"key": "SPRING_DATASOURCE_PASSWORD", "value": "DB_PASSWORD"},
      {"key": "SPRING_REDIS_HOST", "value": "REDIS_HOST"},
      {"key": "SPRING_REDIS_PORT", "value": "REDIS_PORT"},
      {"key": "JWT_SECRET", "value": "'$JWT_SECRET'"},
      {"key": "SERVICE_AUTH_URL", "value": "https://pawfinder-auth-service.onrender.com"},
      {"key": "SERVICE_ALERT_URL", "value": "https://pawfinder-alert-service.onrender.com"},
      {"key": "SERVICE_MESSAGING_URL", "value": "https://pawfinder-messaging-service.onrender.com"},
      {"key": "SERVICE_REWARD_URL", "value": "https://pawfinder-reward-service.onrender.com"},
      {"key": "SERVICE_MEDIA_URL", "value": "https://pawfinder-media-service.onrender.com"},
      {"key": "SERVICE_ANALYTICS_URL", "value": "https://pawfinder-analytics-service.onrender.com"},
      {"key": "SERVICE_MATCHING_URL", "value": "https://pawfinder-matching-service.onrender.com"},
      {"key": "SERVICE_NOTIFICATION_URL", "value": "https://pawfinder-notification-service.onrender.com"}
    ],
    "autoDeploy": "yes"
  }'
```

> ⚠️ Replace `DB_HOST`, `DB_PASSWORD`, `REDIS_HOST`, `REDIS_PORT` with actual values from D2/D3.

#### Deploy Auth Service

```powershell
curl -s -X POST "https://api.render.com/v1/services" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "ownerId": "'$env:RENDER_OWNER_ID'",
    "type": "web_service",
    "name": "pawfinder-auth-service",
    "repo": "github.com/LeGoober/PawFinder-App",
    "branch": "main",
    "runtime": "docker",
    "rootDir": "pawfinder-app-backend",
    "dockerfilePath": "Dockerfile.auth-service",
    "plan": "starter",
    "region": "oregon",
    "healthCheckPath": "/actuator/health",
    "envVars": [
      {"key": "SPRING_PROFILES_ACTIVE", "value": "prod"},
      {"key": "SPRING_DATASOURCE_URL", "value": "jdbc:postgresql://DB_HOST:5432/pawfinder"},
      {"key": "SPRING_DATASOURCE_USERNAME", "value": "pawfinder"},
      {"key": "SPRING_DATASOURCE_PASSWORD", "value": "DB_PASSWORD"},
      {"key": "JWT_SECRET", "value": "'$JWT_SECRET'"},
      {"key": "TWILIO_ACCOUNT_SID", "value": "YOUR_TWILIO_SID"},
      {"key": "TWILIO_AUTH_TOKEN", "value": "YOUR_TWILIO_TOKEN"},
      {"key": "TWILIO_PHONE_NUMBER", "value": "YOUR_TWILIO_PHONE"}
    ],
    "autoDeploy": "yes"
  }'
```

#### Deploy Remaining Services (Same Pattern)

Repeat the above with the corresponding `dockerfilePath` and env vars. For cost-saving, deploy only what you need in V0.1:

| Priority | Services | Monthly |
|----------|----------|---------|
| **Minimum viable** | auth, alert, messaging + gateway + frontend + DB + Redis | ~$35 |
| **Core features** | + reward, media, notification | ~$56 |
| **Full platform** | + analytics, matching | ~$70 |

#### Deploy via Convenience Script

Save all services in a single deploy script for repeatability:

```powershell
# deploy-render.ps1 — Run once to create all services
param(
  [Parameter(Mandatory)]$ApiKey,
  [Parameter(Mandatory)]$OwnerId,
  [Parameter(Mandatory)]$DbHost,
  [Parameter(Mandatory)]$DbPassword,
  [Parameter(Mandatory)]$RedisHost,
  [Parameter(Mandatory)]$RedisPort,
  [Parameter(Mandatory)]$JwtSecret
)

$headers = @{
  Authorization = "Bearer $ApiKey"
  "Content-Type" = "application/json"
}

$base = @{
  ownerId = $OwnerId
  repo = "github.com/LeGoober/PawFinder-App"
  branch = "main"
  runtime = "docker"
  rootDir = "pawfinder-app-backend"
  plan = "starter"
  region = "oregon"
  healthCheckPath = "/actuator/health"
  autoDeploy = "yes"
}

$services = @(
  @{Name="pawfinder-api-gateway";    Dockerfile="Dockerfile.api-gateway";    EnvVars=@(
    @{k="SPRING_PROFILES_ACTIVE";v="prod"}, @{k="SPRING_DATASOURCE_URL";v="jdbc:postgresql://$DbHost/pawfinder"},
    @{k="SPRING_DATASOURCE_USERNAME";v="pawfinder"}, @{k="SPRING_DATASOURCE_PASSWORD";v=$DbPassword},
    @{k="SPRING_REDIS_HOST";v=$RedisHost}, @{k="SPRING_REDIS_PORT";v=$RedisPort},
    @{k="JWT_SECRET";v=$JwtSecret}
  )},
  @{Name="pawfinder-auth-service";    Dockerfile="Dockerfile.auth-service";    EnvVars=@(
    @{k="SPRING_PROFILES_ACTIVE";v="prod"}, @{k="SPRING_DATASOURCE_URL";v="jdbc:postgresql://$DbHost/pawfinder"},
    @{k="SPRING_DATASOURCE_USERNAME";v="pawfinder"}, @{k="SPRING_DATASOURCE_PASSWORD";v=$DbPassword},
    @{k="JWT_SECRET";v=$JwtSecret}
  )},
  @{Name="pawfinder-alert-service";   Dockerfile="Dockerfile.alert-service";   EnvVars=@(
    @{k="SPRING_PROFILES_ACTIVE";v="prod"}, @{k="SPRING_DATASOURCE_URL";v="jdbc:postgresql://$DbHost/pawfinder"},
    @{k="SPRING_DATASOURCE_USERNAME";v="pawfinder"}, @{k="SPRING_DATASOURCE_PASSWORD";v=$DbPassword},
    @{k="REDIS_URL";v="redis://${RedisHost}:$RedisPort"},
    @{k="JWT_SECRET";v=$JwtSecret}
  )}
  # Add messaging, reward, media, analytics, matching, notification as needed
)

foreach ($svc in $services) {
  $payload = @{
    ownerId = $base.ownerId
    type = "web_service"
    name = $svc.Name
    repo = $base.repo
    branch = $base.branch
    runtime = $base.runtime
    rootDir = $base.rootDir
    dockerfilePath = $svc.Dockerfile
    plan = $base.plan
    region = $base.region
    healthCheckPath = $base.healthCheckPath
    autoDeploy = $base.autoDeploy
    envVars = ($svc.EnvVars | ForEach-Object { @{key=$_.k; value=$_.v} })
  } | ConvertTo-Json -Depth 5

  Write-Host "Creating $($svc.Name)..." -ForegroundColor Cyan
  $result = Invoke-RestMethod -Method Post -Uri "https://api.render.com/v1/services" `
    -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($payload))
  Write-Host "  ✓ Created: $($result.service.id)" -ForegroundColor Green
}
```

### Step D6: Set Up Deploy Hooks for Each Service

After all services are created, get each service's deploy hook:

```powershell
# List all services with their deploy hooks
curl -s "https://api.render.com/v1/services?name=pawfinder-" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" | jq '.[] | {name: .service.name, hook: .service.deployHook}'
```

Add each as a GitHub Secret or in your CI script. The CI pipeline already supports `RENDER_DEPLOY_HOOK_URL` — you can set this to trigger all services or set per-service hooks.

### Step D7: Update Frontend → Gateway URL

```powershell
# Get the frontend service ID
$FRONTEND_ID = $(curl -s "https://api.render.com/v1/services?name=pawfinder-frontend" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" | jq -r '.[0].service.id')

# Update env var
curl -s -X PUT "https://api.render.com/v1/services/$FRONTEND_ID/env-vars/API_BASE_URL" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"value": "https://pawfinder-api-gateway.onrender.com"}'
```

### Step D8: Trigger First Deploy

```powershell
# Deploy all services
$SERVICES = $(curl -s "https://api.render.com/v1/services" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" | jq -r '.[].service | select(.name | startswith("pawfinder-")) | .id')

foreach ($id in $SERVICES) {
  echo "Deploying $id..."
  curl -s -X POST "https://api.render.com/v1/services/$id/deploys" \
    -H "Authorization: Bearer $env:RENDER_API_KEY"
}
```

### Daily Workflow with CLI

Once services exist, the daily loop is:

```powershell
# 1. Push code to GitHub
cd C:\Users\roris\Desktop\5.projects\2.java_projects\4.personal_projects\19.Paws
git push origin main

# 2. Trigger deploy for just the service(s) you changed
curl -s -X POST "https://api.render.com/v1/services/$AUTH_SERVICE_ID/deploys" \
  -H "Authorization: Bearer $env:RENDER_API_KEY"

# 3. Check deploy status
curl -s "https://api.render.com/v1/services/$AUTH_SERVICE_ID/deploys?limit=1" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" | jq '.[0].deploy.status'
```

---

## Path B: Manual Dashboard Deployment

**Goal:** 3-5 Render resources — Frontend, API Gateway, Auth+Core, DB, Redis.
**Cost:** ~$28-35/month | **Time:** 20 minutes.

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
   - **Dockerfile Path:** `Dockerfile` (auto-detected in root directory)
   - **Plan:** Starter ($7/mo)
   - **Health Check Path:** `/`
4. **Environment Variables** tab — add:
   | Key | Value |
   |-----|-------|
   | `API_BASE_URL` | `https://pawfinder-api-gateway.onrender.com` |

   > ⚠️ Wait until after Step 4 to set this — you need the API Gateway URL first. Leave blank for now, come back after the gateway is deployed.

5. Click **Create Web Service** — Render auto-detects `Dockerfile` in the root directory and builds (Flutter → Nginx).

### Step 4: Deploy API Gateway

1. Render Dashboard → **New** → **Web Service**
2. Connect repo: `LeGoober/PawFinder-App`
3. Configure:
   - **Name:** `pawfinder-api-gateway`
   - **Root Directory:** `pawfinder-app-backend`
   - **Runtime:** Docker
   - **Dockerfile Path:** `Dockerfile.api-gateway` ⚠️ **Critical:** Must match the per-service Dockerfile name exactly
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
   | `JWT_SECRET` | `<generated-from-openssl>` |

   > **Consolidation note:** If you're only deploying 1-2 backend services (cost-saving), point ALL service URLs to the same service (e.g., `http://pawfinder-auth-service:8080`). The auth service will run with all Spring profiles active.
   > 
   > **If deploying all services separately:** Point each URL to its corresponding Render service (`pawfinder-alert-service`, `pawfinder-messaging-service`, etc.).

5. Click **Create Web Service**.

### Step 5: Deploy Auth Service (and optionally other backends)

For **each** backend service you want to deploy separately, repeat this pattern:

1. Render Dashboard → **New** → **Web Service**
2. Connect repo: `LeGoober/PawFinder-App`
3. Configure:
   - **Name:** `pawfinder-auth-service` (or `pawfinder-alert-service`, etc.)
   - **Root Directory:** `pawfinder-app-backend`
   - **Runtime:** Docker
   - **Dockerfile Path:** Must be the **per-service Dockerfile** — see table below:
     | Service | Dockerfile Path |
     |---------|----------------|
     | Auth | `Dockerfile.auth-service` |
     | Alert | `Dockerfile.alert-service` |
     | Messaging | `Dockerfile.messaging-service` |
     | Reward | `Dockerfile.reward-service` |
     | Media | `Dockerfile.media-service` |
     | Analytics | `Dockerfile.analytics-service` |
     | Matching | `Dockerfile.matching-service` |
     | Notification | `Dockerfile.notification-service` |
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

## Path A: Blueprint One-Click (render.yaml)

Deploy everything at once using `render.yaml`. The blueprint references per-service Dockerfiles
(e.g., `Dockerfile.auth-service`, `Dockerfile.alert-service`) — **no build args needed.**

### Steps

1. Add payment method to Render
2. Verify `render.yaml` is committed and pushed to GitHub `main`:
   ```powershell
   git log --oneline -1 render.yaml
   ```
3. Render Dashboard → **Blueprints** → **New Blueprint Instance**
4. Connect `LeGoober/PawFinder-App`
5. Render reads `render.yaml` and creates all resources:
   - 1 frontend (web service, Docker)
   - 8 backend services (web services, Docker)
   - API Gateway (web service, Docker) — 10 Docker services total
   - 1 PostgreSQL (`pawfinder-db`)
   - 1 Redis (`pawfinder-redis`)
6. Wait for initial deploy (10-15 minutes for all services)
7. Set `sync: false` env vars manually (Twilio, Stripe, AWS, etc.)
8. Enable PostGIS on `pawfinder-db`:
   - Dashboard → `pawfinder-db` → Shell → `CREATE EXTENSION IF NOT EXISTS postgis;`

### Blueprint Files Structure (what Render sees)

```
pawfinder-app-backend/
├── Dockerfile                  # Generic (uses --build-arg, NOT used by blueprint)
├── Dockerfile.api-gateway      # Hardcoded for pawfinder-api-gateway
├── Dockerfile.auth-service     # Hardcoded for pawfinder-auth-service
├── Dockerfile.alert-service    # Hardcoded for pawfinder-alert-service
├── Dockerfile.messaging-service
├── Dockerfile.reward-service
├── Dockerfile.media-service
├── Dockerfile.analytics-service
├── Dockerfile.matching-service
├── Dockerfile.notification-service
├── pom.xml                     # Parent Maven POM
├── pawfinder-api-gateway/
├── pawfinder-auth-service/
├── pawfinder-alert-service/
├── ...
└── pawfinder-shared/
```

> **Note:** Each per-service Dockerfile hardcodes its service name (e.g., `COPY pawfinder-auth-service/pom.xml`) because Render Blueprint **does not support `--build-arg`**. The generic `Dockerfile` (with `ARG SERVICE_NAME`) is for local/manual builds only.

### Known Blueprint Issues

| Issue | Symptom | Fix |
|-------|---------|-----|
| Build timeout | Service stuck in "Building..." | Services build sequentially in blueprint; wait longer or use Path D |
| Missing Dockerfile | "Dockerfile not found at path" | Verify the exact filename (e.g., `Dockerfile.auth-service`, not `Dockerfile.auth`) |
| Build context too large | Slow builds, OOM on free CI minutes | Blueprint copies entire repo to each build context |
| Service URL resolution | Gateway can't reach backends | Verify `fromService` references match exact service names |
| Duplicate YAML keys | Blueprint parse error | Our `render.yaml` has been checked; if you edit it, validate with `yamllint` |

**If the Blueprint fails → use Path D (CLI/API) instead.** The CLI gives you per-service control and better error visibility.

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

## Per-Service Container Deployment Reference

Every backend service has its own Dockerfile in `pawfinder-app-backend/`. These hardcode
the service name because Render Blueprint doesn't support `--build-arg`. The generic
`Dockerfile` (with `ARG SERVICE_NAME`) is for local/manual builds only.

### Dockerfile → Service Mapping

| Service | Dockerfile | Port | Key Dependencies |
|---------|-----------|------|-----------------|
| Frontend | `pawfinder_app_frontend/Dockerfile` | 80 | None (Nginx static) |
| API Gateway | `Dockerfile.api-gateway` | 8080 | JWT, Redis (session cache) |
| Auth | `Dockerfile.auth-service` | 8080 | DB, JWT, Twilio, Google OAuth |
| Alert | `Dockerfile.alert-service` | 8080 | DB, JWT, Redis, PostGIS |
| Messaging | `Dockerfile.messaging-service` | 8080 | DB, JWT |
| Reward | `Dockerfile.reward-service` | 8080 | DB, JWT, Stripe |
| Media | `Dockerfile.media-service` | 8080 | AWS S3, JWT |
| Analytics | `Dockerfile.analytics-service` | 8080 | DB, JWT |
| Matching | `Dockerfile.matching-service` | 8080 | AWS Rekognition, JWT |
| Notification | `Dockerfile.notification-service` | 8080 | Firebase FCM, SendGrid, JWT |

### Local Build Test (Verify Before Deploying)

```powershell
cd pawfinder-app-backend

# Build a specific service container locally
docker build -f Dockerfile.auth-service -t pawfinder-auth:test .

# Run it (requires local DB on 5433)
docker run -p 8081:8080 \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5433/pawfinder \
  -e SPRING_DATASOURCE_USERNAME=pawfinder \
  -e SPRING_DATASOURCE_PASSWORD=pawfinder_dev \
  -e JWT_SECRET=dev-secret \
  -e SPRING_PROFILES_ACTIVE=dev \
  pawfinder-auth:test

# Verify
curl http://localhost:8081/actuator/health
# Expected: {"status":"UP"}
```

### Render Dashboard Config (One Service)

When creating a backend service in Render Dashboard:

| Field | Value |
|-------|-------|
| **Name** | `pawfinder-<service-name>` |
| **Region** | Oregon (US West) |
| **Repo** | `LeGoober/PawFinder-App` |
| **Branch** | `main` |
| **Root Directory** | `pawfinder-app-backend` |
| **Runtime** | Docker |
| **Dockerfile Path** | `Dockerfile.<service-name>` ⚠️ Exact filename from table above |
| **Plan** | Starter ($7/mo) |
| **Health Check** | `/actuator/health` |
| **Port** | 8080 (Render assigns external port automatically) |

### Render API Config (One Service)

```powershell
curl -X POST "https://api.render.com/v1/services" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "ownerId": "'$env:RENDER_OWNER_ID'",
    "type": "web_service",
    "name": "pawfinder-<service-name>",
    "repo": "github.com/LeGoober/PawFinder-App",
    "branch": "main",
    "runtime": "docker",
    "rootDir": "pawfinder-app-backend",
    "dockerfilePath": "Dockerfile.<service-name>",
    "plan": "starter",
    "region": "oregon",
    "healthCheckPath": "/actuator/health",
    "autoDeploy": "yes",
    "envVars": [
      {"key": "SPRING_PROFILES_ACTIVE", "value": "prod"},
      ...
    ]
  }'
```

### Build Time Estimates (First Deploy)

| Service | Maven Download + Build | Docker Push | Total |
|---------|----------------------|-------------|-------|
| Frontend | ~4 min (Flutter SDK pull + web build) | ~1 min | ~5 min |
| Any backend | ~3 min (Maven deps + compile) | ~1 min | ~4 min |

> Subsequent deploys are faster due to Docker layer caching.

### Deploy Order (Important!)

1. **DB + Redis** — infrastructure first
2. **Auth Service** — core dependency for gateway
3. **API Gateway** — needs at least one backend to route to
4. **Alert, Messaging, etc.** — remaining backends
5. **Frontend** — set `API_BASE_URL` after gateway deploys

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
| Backend won't start | `SERVICE_NAME` build arg wrong | Per-service Dockerfiles hardcode the name — use `Dockerfile.auth-service` not build args |
| Build fails: flutter not found | Runtime is `static` not `docker` | Use Docker runtime for frontend |
| Render Blueprint "Build failed" | Monorepo context too large | Use Path D (CLI/API) for per-service deploys |
| Docker build OOM | Memory limit on free plan | Upgrade to Starter plan or use smaller base images |
| Health check fails on startup | Java app takes 30-60s to boot | Increase health check grace period in Render settings |

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

## Troubleshooting Blueprint & Deploy Failures

### Render Blueprint Common Failures

#### 1. "Blueprint failed to create resources"
**Most likely cause:** Missing payment method. Render won't create paid resources without a card.
**Fix:** Dashboard → Account → Billing → Add card.

#### 2. "Service not found" or "Dockerfile not found"
**Most likely cause:** Wrong `dockerfilePath` in `render.yaml` or the per-service Dockerfile isn't pushed.
**Fix:**
```powershell
# Verify files are on GitHub (not just local)
git log --oneline -5
git push origin main

# Verify specific Dockerfile exists
# Check: https://github.com/LeGoober/PawFinder-App/blob/main/pawfinder-app-backend/Dockerfile.auth-service
```

#### 3. "Build context too large" or build hangs
**Most likely cause:** Render copies the entire monorepo to EVERY service's build context.
That's ~500MB+ copied 10 times.
**Fix:** Use Path D (CLI/API) — deploy services one at a time, or consolidate to fewer services.

#### 4. "fromService cannot resolve pawfinder-..."
**Cause:** Render tries to resolve service URLs before all services are created.
**Fix:** In the Blueprint UI, click "Retry" after all services are green. Or use hardcoded URLs in env vars.

### Docker Build Failures

#### 5. Maven build fails with "Could not resolve dependencies"
```
[ERROR] Failed to execute goal on project pawfinder-auth-service:
Could not resolve dependencies for project com.pawfinder:pawfinder-auth-service:jar:0.0.1-SNAPSHOT
```
**Fix:** The per-service Dockerfile needs the shared module. Verify `pawfinder-shared/` is copied:
```dockerfile
# Each per-service Dockerfile has:
COPY pawfinder-shared/pom.xml pawfinder-shared/
COPY pawfinder-shared/src pawfinder-shared/src/
```
If building locally, run `mvn install -pl pawfinder-shared` first.

#### 6. Flutter build fails with "pub get" errors
**Fix:** Pin Flutter version in the Dockerfile (currently `3.41.6`). If plugins changed, run locally first:
```powershell
cd pawfinder_app_frontend
flutter clean && flutter pub get && flutter build web --release
```
Then push and redeploy.

### Runtime Failures

#### 7. Service starts but /actuator/health returns 503
**Cause:** Spring Boot can't connect to DB or Redis.
**Fix:** Check env vars in Render dashboard → service → Environment. Verify:
- `SPRING_DATASOURCE_URL` uses the correct Render DB host (NOT localhost)
- DB password matches what Render generated
- Redis URL is correct (if required)

#### 8. API Gateway returns 502 for backend routes
**Cause:** Service URL env vars point to non-existent or wrong service.
**Fix:** If consolidating, ensure ALL service URLs point to the consolidated service:
```
AUTH_SERVICE_URL=http://pawfinder-auth-service:8080
ALERT_SERVICE_URL=http://pawfinder-auth-service:8080
... (all point to same service)
```
If deploying separately, each URL must match the exact Render service name.

#### 9. Frontend loads but shows CORS errors in console
**Cause:** Flutter web makes API calls from `pawfinder-frontend.onrender.com` but gateway allows only `localhost`.
**Fix:** Update gateway CORS config to allow the Render frontend origin, or use the Nginx proxy approach.

#### 10. Cold start latency (30-60s on first request)
**Cause:** Render Starter plan spins down after 15 minutes of inactivity.
**Fix:** 
- Upgrade to Individual plan ($19/mo/service — no cold starts)
- Set up a cron job (or UptimeRobot) to ping `/actuator/health` every 10 minutes
- Add a timeout/loading state in the Flutter frontend

### Debugging Deploy Logs

```powershell
# View latest deploy logs for a service via API
$SERVICE_ID="srv-..."

# Get latest deploy
$DEPLOY_ID=$(curl -s "https://api.render.com/v1/services/$SERVICE_ID/deploys?limit=1" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" | jq -r '.[0].deploy.id')

# Get build logs
curl -s "https://api.render.com/v1/services/$SERVICE_ID/deploys/$DEPLOY_ID" \
  -H "Authorization: Bearer $env:RENDER_API_KEY" | jq '.deploy'
```

Or in Render Dashboard: service → Events/Logs tab → filter by "Deploy".

---

## Cost Estimates

### Path D — CLI/API ($28-70/mo depending on service count)

| Configuration | Services | Monthly |
|--------------|----------|---------|
| Minimum (auth+alert+gateway) | 3 Docker + DB + Redis | $28 |
| Core (add messaging, reward, media, notification) | 6 Docker + DB + Redis | $49 |
| Full (all 9 backends) | 9 Docker + DB + Redis | $70 |

### Path B — Manual Dashboard ($28/mo)

| Resource | Monthly |
|----------|---------|
| Frontend (Docker) | $7 |
| API Gateway | $7 |
| Auth+Consolidated | $7 |
| PostgreSQL | $7 |
| Redis | $0 |
| **Total** | **$28** |

### Path A — Full Blueprint ($70/mo)

| Resource | Monthly |
|----------|---------|
| 9 Docker services | $63 |
| PostgreSQL | $7 |
| Redis | $0 |
| **Total** | **$70** |

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
- [x] Per-service Dockerfiles for frontend + all 9 backend services
- [x] Generic `Dockerfile` with `--build-arg` (for local/manual builds)
- [x] `render.yaml` Blueprint (reference per-service Dockerfiles)
- [x] `.github/workflows/deploy.yml` CI/CD
- [x] Secrets stripped from git history
- [x] `docs/GOOGLE_AUTH_SETUP.md`
- [x] `docs/RENDER_ENV_VARS.txt` (env var reference with placeholders)
- [x] `docs/DEPLOYMENT.md` (this guide)

### To Deploy (Pick Your Path)
- [ ] Add payment method to Render (required for Starter plans)
- [ ] Create Render API key (Path D) or use Dashboard (Path B)
- [ ] Verify all per-service Dockerfiles pushed to GitHub
- [ ] Create DB + Redis on Render
- [ ] Enable PostGIS on DB
- [ ] Deploy backend services (order: auth → gateway → rest)
- [ ] Set all env vars per service (JWT_SECRET, Twilio, Stripe, etc.)
- [ ] Deploy frontend with `API_BASE_URL` pointing to gateway
- [ ] Configure Google OAuth origins/redirects for Render domain
- [ ] Set Stripe webhook (if using rewards)
- [ ] Set `RENDER_DEPLOY_HOOK_URL` GitHub secret (for CI/CD auto-deploy)
- [ ] Verify all services healthy
- [ ] Test full auth flow
- [ ] Set up cold-start ping (UptimeRobot or cron)
