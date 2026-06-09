# PawFinder — External API Procurement Guide

> **Date:** 2026-06-10
> **Purpose:** Complete list of every external API/service key needed, which service consumes it, how to get it, and priority order.

---

## Priority Tiers

| Tier | Meaning |
|------|---------|
| 🔴 **P0 — Critical path** | App won't function without this. Blocking. |
| 🟠 **P1 — Core feature** | Key feature broken without it. Start now. |
| 🟡 **P2 — Important** | Degraded experience without it. |
| 🟢 **P3 — Nice to have** | Monitoring, analytics, polish. |

---

## 1. Stripe (Payments & Rewards) 🔴 P0

**Consumed by:** `pawfinder-reward-service` (port 8084), Flutter frontend

**Env vars needed:**
```
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

**How to get:**
1. Go to https://dashboard.stripe.com/register — create a free account
2. Switch to **Test mode** (toggle in dashboard top-right)
3. **Secret key:** Dashboard → Developers → API keys → "Secret key" (`sk_test_...`)
4. **Publishable key:** Same page → "Publishable key" (`pk_test_...`)
5. **Webhook secret:** Developers → Webhooks → Add endpoint → `https://your-domain/stripe/webhook` → select event `payment_intent.succeeded` → get signing secret (`whsec_...`). For local dev, install Stripe CLI and run `stripe listen --forward-to localhost:8084/stripe/webhook`

**Cost:** Free in test mode. Production: 2.9% + $0.30 per transaction.

**What it powers:** Reward escrow — owners attach money to alerts, finders get paid on successful reunion. Platform takes 5-10% fee.

---

## 2. Firebase (Auth, Push Notifications, Crashlytics) 🔴 P0

**Consumed by:** Flutter frontend, `pawfinder-notification-service` (port 8088)

**Env vars needed:**
```
FIREBASE_SERVER_KEY=AAAA... (FCM server key)
```

**Flutter needs:** `google-services.json` (Android) + `GoogleService-Info.plist` (iOS) placed in the respective platform directories.

**How to get:**
1. Go to https://console.firebase.google.com/ — create a free project named "PawFinder"
2. **Android app:** Project settings → Add app → Android → package name `com.example.pawfinder_app` → download `google-services.json`
3. **iOS app:** Add app → iOS → bundle ID → download `GoogleService-Info.plist`
4. **FCM Server Key:** Project settings → Cloud Messaging → Server key (or use the newer Cloud Messaging API → enable the API → get service account key)
5. Enable **Authentication** (Email/Password + Google + Apple sign-in providers)
6. Enable **Crashlytics** and **Analytics**

**Cost:** Free tier is generous (unlimited analytics, 100k auth/month, free crash reporting).

**What it powers:** User authentication (email, Google, Apple sign-in), push notifications for new alerts and sightings, crash reporting, analytics.

---

## 3. AWS (S3 Storage + Rekognition + SES) 🔴 P0

**Consumed by:** `pawfinder-media-service` (port 8085), `pawfinder-matching-service` (port 8087)

**Env vars needed:**
```
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1
AWS_S3_BUCKET=pawfinder-media-dev
```

**How to get:**
1. Go to https://aws.amazon.com/ → create a free account (credit card required)
2. **IAM User:** IAM → Users → Create user → "pawfinder-dev" → Attach policies:
   - `AmazonS3FullAccess`
   - `AmazonRekognitionFullAccess`
   - `AmazonSESFullAccess`
3. Create access key → download CSV with `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
4. **S3 Bucket:** S3 → Create bucket → `pawfinder-media-dev` → region `us-east-1` → block public access ON
5. **SES:** SES → Verify a domain or email address for sending (needed for email fallback)

**Cost:** Free tier includes 5GB S3, 20k SES emails/month. Rekognition: first 5k images/month free, then $1 per 1k images.

**What it powers:** Pet photo uploads and storage (S3), AI image analysis to detect pets/verify sightings (Rekognition), transactional email fallback (SES).

---

## 4. Twilio (SMS Verification) 🟠 P1

**Consumed by:** `pawfinder-auth-service` (port 8081), `pawfinder-notification-service` (port 8088)

**Env vars needed:**
```
TWILIO_ACCOUNT_SID=AC...
TWILIO_AUTH_TOKEN=...
TWILIO_PHONE_NUMBER=+1234567890
```

**How to get:**
1. Go to https://www.twilio.com/ → sign up (trial credit included)
2. Dashboard → Account SID + Auth Token
3. Phone Numbers → Buy a number → choose SMS-capable number → gets `TWILIO_PHONE_NUMBER`

**Cost:** ~$0.0075 per SMS. Trial credit covers initial development.

**What it powers:** Phone number verification for new accounts (anti-spam). SMS notifications for urgent alerts.

---

## 5. SendGrid (Transactional Email) 🟠 P1

**Consumed by:** `pawfinder-notification-service` (port 8088)

**Env vars needed:**
```
SENDGRID_API_KEY=SG....
```

**How to get:**
1. Go to https://sendgrid.com/ → sign up (free tier: 100 emails/day)
2. Settings → API Keys → Create API Key → "Full Access" → copy key (starts with `SG.`)

**Cost:** Free tier: 100 emails/day. Paid: $19.95/mo for 50k emails.

**What it powers:** Email notifications — "your pet was sighted", "new message from finder", account verification.

---

## 6. Google Maps Platform (Maps & Geocoding) 🟠 P1

**Consumed by:** Flutter frontend (`google_maps_flutter`)

**Env vars needed:**
```
# In Flutter: lib/core/constants/app_constants.dart
GOOGLE_MAPS_API_KEY=AIza...
```

**Flutter setup:** The key goes in:
- `android/app/src/main/AndroidManifest.xml` — `<meta-data android:name="com.google.android.geo.API_KEY" .../>`
- `ios/Runner/AppDelegate.swift` — `GMSServices.provideAPIKey(...)`

**How to get:**
1. Go to https://console.cloud.google.com/ → create project → enable billing (free credit)
2. APIs & Services → Library → enable:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Geocoding API**
   - **Places API**
3. Credentials → Create API Key → restrict to the above APIs
4. Google gives $200/month free credit (covers ~28,000 map loads)

**Cost:** $200/month free credit. Beyond that: $7 per 1k map loads.

**What it powers:** Interactive map showing missing pets, geocoding addresses to coordinates, place search for "last seen" location.

---

## 7. JWT Secret (Internal, not an external service) 🟡 P2

**Consumed by:** All backend services

**Env vars needed:**
```
JWT_SECRET=<256-bit random string>
JWT_EXPIRATION=86400000
```

**How to generate:**
```bash
# On any machine:
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
# or PowerShell:
[Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Maximum 256 }))
```

**Note:** Already set with dev defaults. Only needs changing for production.

---

## 8. Sentry (Error Tracking) 🟢 P3

**Consumed by:** Flutter (`sentry_flutter`), Java (`sentry-spring-boot`)

**Env vars needed:**
```
SENTRY_DSN=https://...@sentry.io/...
```

**How to get:**
1. Go to https://sentry.io/ → sign up → create project (Flutter + Java)
2. Settings → Projects → Client Keys (DSN)

**Cost:** Free tier: 5k errors/month. Team: $26/month.

**What it powers:** Crash reporting, performance monitoring, error aggregation.

---

## 9. Mixpanel (Product Analytics) 🟢 P3

**Consumed by:** Flutter (`mixpanel_flutter`)

**Env vars needed:**
```
MIXPANEL_TOKEN=...
```

**How to get:**
1. Go to https://mixpanel.com/ → sign up
2. Settings → Project Settings → Token

**Cost:** Free up to 20M events/month. Paid tiers start at $20/month.

**What it powers:** User behavior analytics, funnel tracking, retention metrics.

---

## 10. Datadog (Infrastructure Monitoring) 🟢 P3

**Consumed by:** All backend services (Micrometer registry)

**Env vars needed:**
```
DATADOG_API_KEY=...
```

**How to get:**
1. Go to https://www.datadoghq.com/ → sign up
2. Integrations → APIs → API Keys

**Cost:** Free tier: 1-day retention. Pro: $15/host/month.

**What it powers:** APM, infrastructure monitoring, distributed tracing.

---

## 11. Mapbox (Alternative Maps) 🟢 P3

**Consumed by:** Flutter (`flutter_map`) — fallback if Google Maps isn't available

**Env vars needed:**
```
MAPBOX_ACCESS_TOKEN=pk...
```

**How to get:**
1. Go to https://www.mapbox.com/ → sign up
2. Account → Access tokens → default public token

**Cost:** Free up to 50k map loads/month.

**What it powers:** Alternative map provider with custom styling (used if Google Maps quota exceeded or unavailable).

---

## Quick-Start Priority

```
Session 1 (today):    Stripe ★      Firebase ★      AWS ★
Session 2:            Twilio ★      SendGrid ★      Google Maps ★
Session 3:            JWT rotation  Sentry          Mixpanel
Session 4:            Datadog       Mapbox
```

**Bare minimum to start backend + frontend end-to-end:**
Stripe + Firebase + AWS + Twilio + SendGrid + Google Maps (6 APIs).

---

## After Getting Each Key

Paste into `pawfinder-app-backend/.env`:
```env
# After getting Stripe:
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...

# After getting Firebase:
FIREBASE_SERVER_KEY=AAAA...

# After getting AWS:
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_S3_BUCKET=pawfinder-media-dev

# After getting Twilio:
TWILIO_ACCOUNT_SID=AC...
TWILIO_AUTH_TOKEN=...
TWILIO_PHONE_NUMBER=+1...

# After getting SendGrid:
SENDGRID_API_KEY=SG....
```

`.env` is gitignored — it won't be committed. The template is in `.env.example`.

---

*Built by Claw — your J.A.R.V.I.S to your Tony Stark.* 🤖
