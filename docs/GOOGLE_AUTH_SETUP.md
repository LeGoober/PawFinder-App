# Google Sign-In Setup Guide

> **For:** PawFinder Flutter Web | **Last Updated:** 2026-06-15

---

## Overview

PawFinder uses Google OAuth 2.0 for sign-in. The backend's existing
`POST /api/v1/auth/login` endpoint accepts `{authProvider, authId}` —
Google provides the user ID, and the backend creates or retrieves the
account, returning JWT tokens.

**You need a Google Cloud Console project with an OAuth 2.0 Client ID.**

---

## Step 1: Create a Google Cloud Project

1. Go to https://console.cloud.google.com
2. Create a new project (or select an existing one)
3. Name it `PawFinder` (or anything you prefer)

## Step 2: Configure OAuth Consent Screen

1. Navigate to **APIs & Services** → **OAuth consent screen**
2. Choose **External** user type
3. Fill in:
   - **App name:** PawFinder
   - **User support email:** your email
   - **Developer contact:** your email
4. Add scopes: `email`, `profile`, `openid`
5. Add test users (your email + any testers)
6. Save and continue

## Step 3: Create OAuth 2.0 Client ID

1. Navigate to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **OAuth 2.0 Client ID**
3. Choose **Web application**
4. Configure:

   | Field | Value |
   |-------|-------|
   | **Name** | PawFinder Web |
   | **Authorized JavaScript origins** | `http://localhost` |
   | | `http://localhost:9876` |
   | | `https://your-app.onrender.com` *(production)* |
   | **Authorized redirect URIs** | `http://localhost:9876` |
   | | `https://your-app.onrender.com` *(production)* |

5. Click **Create**

## Step 3.5: Enable Required APIs

The Google Sign-In plugin requires the **People API** to fetch user
profile info (name, photo, email). Without this, sign-in fails with
a 403 PERMISSION_DENIED error.

1. Go to https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=YOUR_PROJECT_ID
2. Click **Enable**
3. Wait 2–3 minutes for propagation

## Step 4: Add Client ID to PawFinder

Edit `pawfinder_app_frontend/web/index.html`:

```html
<meta name="google-signin-client_id"
      content="123456789-xxxxx.apps.googleusercontent.com">
```

Replace the placeholder `YOUR_GOOGLE_CLIENT_ID.apps.googleusercontent.com`.

## Step 5: Verify

1. Start the backend: `cd pawfinder-app-backend && .\start-all.ps1`
2. Start Flutter web: `cd pawfinder_app_frontend && flutter run -d chrome --web-port 9876`
3. Click **Continue with Google**
4. Select your Google account
5. You should be redirected to the home page (authenticated)

---

## Troubleshooting

### "popup_closed_by_user" or blank popup
- Check that `http://localhost:9876` is in Authorized JavaScript origins
- Disable popup blocker for `localhost`
- Clear browser cache and cookies for `localhost`

### "idpiframe_initialization_failed"
- Third-party cookies may be blocked (Chrome incognito, Safari)
- Add `accounts.google.com` to allowed sites
- Or test in a regular Chrome window

### "Invalid client ID"
- Ensure the Client ID is correctly pasted in `web/index.html`
- The Client ID must be for "Web application" type, not "Android" or "iOS"

---

## Dev Mode (Skip Google Setup)

For local development without Google Cloud Console:

1. The login page shows a **"Development sign-in"** link in debug builds
2. Clicking it calls `POST /api/v1/auth/login` with:
   ```json
   { "authProvider": "google", "authId": "dev-user-0001" }
   ```
3. The backend creates a user with `displayName: "User-dev-user-0"` and returns JWT
4. This only works when the backend auth service is running

The dev sign-in link is hidden in release builds (`kDebugMode` check).

---

## Mobile (Android/iOS) — Future

For Android and iOS builds, the Google Sign-In configuration differs:

| Platform | Config Location | What You Need |
|----------|----------------|---------------|
| **Android** | `android/app/google-services.json` | Firebase project (or Google Cloud OAuth Android client) |
| **iOS** | `ios/Runner/Info.plist` | `CFBundleURLTypes` with reversed client ID |
| **Web** | `web/index.html` | `<meta name="google-signin-client_id">` |

The same Google Cloud Console project can have multiple OAuth client IDs
(one for each platform). This will be configured during the mobile CI/CD
phase (V0.2).
