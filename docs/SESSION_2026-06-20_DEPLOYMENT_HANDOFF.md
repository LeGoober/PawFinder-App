# Session Handoff — PawFinder Render Deployment
## 2026-06-20

### Current State
- **Repo:** `github.com/LeGoober/PawFinder-App` (branch `main`, commit `2cdbc9d`)
- **Status:** Deployment failing on Render — frontend Docker build error
- **Root cause:** `cirrusci/flutter:3.24.0` image removed from Docker Hub (registry deprecated)

### What We Just Fixed
- **File:** `pawfinder_app_frontend/Dockerfile` line 2
- **Change:** `cirrusci/flutter:3.24.0` → `ghcr.io/cirruslabs/flutter:3.24.0`
- **Verified:** `ghcr.io/cirruslabs/flutter:3.24.0` exists (multi-arch: amd64 + arm64)

### What Rori Needs To Do
1. **Commit & push the Dockerfile fix:**
   ```powershell
   cd C:\Users\roris\Desktop\5.projects\2.java_projects\4.personal_projects\19.Paws
   git add pawfinder_app_frontend/Dockerfile
   git commit -m "fix(deploy): switch Flutter image to ghcr.io/cirruslabs (Docker Hub deprecated)"
   git push origin main
   ```
2. **Trigger redeploy on Render** (auto-deploys on push to main, or manually trigger)
3. **If it still fails:** Check Render build logs — possible issues:
   - GHCR rate limiting (Render IP pulls from ghcr.io) → may need `docker build --pull` flag or authenticated pull
   - Flutter SDK version mismatch with `pubspec.yaml` → `sdk: ^3.5.0` should be fine with Flutter 3.24.0
   - `flutter pub get` failures → dependency resolution might need `--no-fatal-infos` flag

### Architecture Overview (for fresh context)

```
PawFinder V0.1 — 10 Render services + managed DB/Redis
├── pawfinder-frontend (web)     — Flutter Web via Nginx (Docker)
├── pawfinder-api-gateway (web)  — Spring Boot, WebFlux, port 8080
├── pawfinder-auth-service (web) — Spring Boot, Twilio SMS
├── pawfinder-alert-service (web)— Spring Boot, PostGIS
├── pawfinder-messaging-service  — Spring Boot
├── pawfinder-reward-service     — Spring Boot, Stripe
├── pawfinder-media-service      — Spring Boot, AWS S3
├── pawfinder-analytics-service  — Spring Boot
├── pawfinder-matching-service   — Spring Boot, AWS Rekognition
├── pawfinder-notification-svc   — Spring Boot, Firebase FCM + SendGrid
├── pawfinder-redis (redis)      — Managed Redis (starter)
└── pawfinder-db (postgres)      — Managed PostgreSQL (starter)
```

### Key Files
| File | Purpose |
|------|---------|
| `render.yaml` | Render Blueprint — all 10 services + DB + Redis |
| `pawfinder_app_frontend/Dockerfile` | Flutter web → Nginx (multi-stage) |
| `pawfinder_app_frontend/nginx.conf` | SPA fallback + gzip + security headers |
| `pawfinder-app-backend/Dockerfile` | Maven build → JRE runtime (per-service via build arg) |
| `docs/DEPLOYMENT.md` | Full deployment guide |
| `docs/GOOGLE_AUTH_SETUP.md` | Google OAuth configuration |
| `start-all.ps1` | Local dev launcher script |

### Known Gaps (pre-existing, not blockers for V0.1 deploy)
- `STRIPE_WEBHOOK_SECRET` = `whsec_change_me` placeholder
- Firebase FCM may need legacy key migration
- No Flutter mobile builds yet (web only)
- No integration tests
- RabbitMQ + Elasticsearch deferred to V0.2
- API Gateway points to `localhost:8081-8088` locally — needs env-var-based routing on Render

### Render Env Vars That Need Manual Entry
These use `sync: false` in `render.yaml` — must be set manually in Render dashboard:
- TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER
- STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET
- AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
- FIREBASE_SERVER_KEY, FIREBASE_PROJECT_ID
- SENDGRID_API_KEY
- JWT_SECRET (auto-generated via `generateValue: true` on auth service, sync to others)

### Render Cost Estimate
- 10x Starter web services @ $7/mo = $70/mo
- 1x Starter PostgreSQL @ $7/mo = $7/mo
- 1x Starter Redis @ $3/mo = $3/mo
- **Total: ~$80/mo** (V0.1)
- See `docs/DEPLOYMENT.md` for cost-reduction options (service consolidation)

### If Deployment Still Has Issues
The next likely failure points after the Flutter image fix:
1. **Backend service discovery** — API Gateway needs to reach downstream services. On Render, these use internal hostnames like `pawfinder-auth-service:8080`. Verify the `fromService` bindings in `render.yaml` resolve correctly.
2. **Database migrations** — Flyway runs on startup. If schema is incompatible, check `pawfinder-auth-service/src/main/resources/db/migration/` for V1-V6.
3. **CORS** — Flutter web on Render domain needs CORS configured in API Gateway to allow the frontend origin.
