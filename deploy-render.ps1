# ────────────────────────────────────────────────────────────
# PawFinder V0.1 — Render CLI Deploy Script
# ────────────────────────────────────────────────────────────
# Creates ALL services on Render via the REST API.
# Run once to set up your Render infrastructure.
#
# Usage:
#   .\deploy-render.ps1 -ApiKey "rnd_..." -OwnerId "tea_..." `
#       -DbHost "pawfinder-db.oregon.render.com" -DbPassword "abc123" `
#       -RedisHost "red-xxxxx.internal" -RedisPort "6379" `
#       -JwtSecret "$(openssl rand -hex 32)"
#
# Prerequisites:
#   1. Render API key: Dashboard → Account Settings → API Keys
#   2. Owner ID: curl -sH "Authorization: Bearer rnd_..." https://api.render.com/v1/owners | jq
#   3. DB + Redis MUST already exist (create via Dashboard or API)
# ────────────────────────────────────────────────────────────

param(
  [Parameter(Mandatory=$true, HelpMessage="Render API key (rnd_...)")]
  [string]$ApiKey,

  [Parameter(Mandatory=$true, HelpMessage="Render owner/team ID (tea_...)")]
  [string]$OwnerId,

  [Parameter(Mandatory=$true, HelpMessage="PostgreSQL internal hostname from Render")]
  [string]$DbHost,

  [Parameter(Mandatory=$true, HelpMessage="PostgreSQL password from Render")]
  [string]$DbPassword,

  [Parameter(Mandatory=$true, HelpMessage="Redis internal hostname from Render")]
  [string]$RedisHost,

  [Parameter(Mandatory=$true, HelpMessage="Redis port (usually 6379)")]
  [string]$RedisPort,

  [Parameter(Mandatory=$true, HelpMessage="JWT secret — use: openssl rand -hex 32")]
  [string]$JwtSecret,

  [Parameter(HelpMessage="Only deploy specific services (comma-separated). Leave empty for all.")]
  [string]$Services = "",

  [Parameter(HelpMessage="Skip frontend deploy")]
  [switch]$SkipFrontend,

  [Parameter(HelpMessage="Dry run — show what would be created without actually creating")]
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$headers = @{
  Authorization = "Bearer $ApiKey"
  "Content-Type" = "application/json"
}

# ── Service Definitions ────────────────────────────────────

$backendServices = @(
  @{
    Name       = "pawfinder-api-gateway"
    Dockerfile = "Dockerfile.api-gateway"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "SPRING_DATASOURCE_URL=jdbc:postgresql://${DbHost}:5432/pawfinder",
      "SPRING_DATASOURCE_USERNAME=pawfinder",
      "SPRING_DATASOURCE_PASSWORD=${DbPassword}",
      "SPRING_REDIS_HOST=${RedisHost}",
      "SPRING_REDIS_PORT=${RedisPort}",
      "JWT_SECRET=${JwtSecret}",
      "SERVICE_AUTH_URL=https://pawfinder-auth-service.onrender.com",
      "SERVICE_ALERT_URL=https://pawfinder-alert-service.onrender.com",
      "SERVICE_MESSAGING_URL=https://pawfinder-messaging-service.onrender.com",
      "SERVICE_REWARD_URL=https://pawfinder-reward-service.onrender.com",
      "SERVICE_MEDIA_URL=https://pawfinder-media-service.onrender.com",
      "SERVICE_ANALYTICS_URL=https://pawfinder-analytics-service.onrender.com",
      "SERVICE_MATCHING_URL=https://pawfinder-matching-service.onrender.com",
      "SERVICE_NOTIFICATION_URL=https://pawfinder-notification-service.onrender.com"
    )
  },
  @{
    Name       = "pawfinder-auth-service"
    Dockerfile = "Dockerfile.auth-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "SPRING_DATASOURCE_URL=jdbc:postgresql://${DbHost}:5432/pawfinder",
      "SPRING_DATASOURCE_USERNAME=pawfinder",
      "SPRING_DATASOURCE_PASSWORD=${DbPassword}",
      "JWT_SECRET=${JwtSecret}",
      "TWILIO_ACCOUNT_SID=TWILIO_ACCOUNT_SID_PLACEHOLDER",
      "TWILIO_AUTH_TOKEN=TWILIO_AUTH_TOKEN_PLACEHOLDER",
      "TWILIO_PHONE_NUMBER=TWILIO_PHONE_NUMBER_PLACEHOLDER"
    )
  },
  @{
    Name       = "pawfinder-alert-service"
    Dockerfile = "Dockerfile.alert-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "SPRING_DATASOURCE_URL=jdbc:postgresql://${DbHost}:5432/pawfinder",
      "SPRING_DATASOURCE_USERNAME=pawfinder",
      "SPRING_DATASOURCE_PASSWORD=${DbPassword}",
      "REDIS_URL=redis://${RedisHost}:${RedisPort}",
      "JWT_SECRET=${JwtSecret}"
    )
  },
  @{
    Name       = "pawfinder-messaging-service"
    Dockerfile = "Dockerfile.messaging-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "SPRING_DATASOURCE_URL=jdbc:postgresql://${DbHost}:5432/pawfinder",
      "SPRING_DATASOURCE_USERNAME=pawfinder",
      "SPRING_DATASOURCE_PASSWORD=${DbPassword}",
      "JWT_SECRET=${JwtSecret}"
    )
  },
  @{
    Name       = "pawfinder-reward-service"
    Dockerfile = "Dockerfile.reward-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "SPRING_DATASOURCE_URL=jdbc:postgresql://${DbHost}:5432/pawfinder",
      "SPRING_DATASOURCE_USERNAME=pawfinder",
      "SPRING_DATASOURCE_PASSWORD=${DbPassword}",
      "STRIPE_SECRET_KEY=STRIPE_SECRET_KEY_PLACEHOLDER",
      "STRIPE_WEBHOOK_SECRET=STRIPE_WEBHOOK_SECRET_PLACEHOLDER",
      "JWT_SECRET=${JwtSecret}"
    )
  },
  @{
    Name       = "pawfinder-media-service"
    Dockerfile = "Dockerfile.media-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY_ID_PLACEHOLDER",
      "AWS_SECRET_ACCESS_KEY=AWS_SECRET_ACCESS_KEY_PLACEHOLDER",
      "AWS_S3_BUCKET=AWS_S3_BUCKET_PLACEHOLDER",
      "AWS_REGION=us-east-1",
      "JWT_SECRET=${JwtSecret}"
    )
  },
  @{
    Name       = "pawfinder-analytics-service"
    Dockerfile = "Dockerfile.analytics-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "SPRING_DATASOURCE_URL=jdbc:postgresql://${DbHost}:5432/pawfinder",
      "SPRING_DATASOURCE_USERNAME=pawfinder",
      "SPRING_DATASOURCE_PASSWORD=${DbPassword}",
      "JWT_SECRET=${JwtSecret}"
    )
  },
  @{
    Name       = "pawfinder-matching-service"
    Dockerfile = "Dockerfile.matching-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "AWS_ACCESS_KEY_ID=AWS_ACCESS_KEY_ID_PLACEHOLDER",
      "AWS_SECRET_ACCESS_KEY=AWS_SECRET_ACCESS_KEY_PLACEHOLDER",
      "AWS_REKOGNITION_REGION=us-east-1",
      "JWT_SECRET=${JwtSecret}"
    )
  },
  @{
    Name       = "pawfinder-notification-service"
    Dockerfile = "Dockerfile.notification-service"
    EnvVars    = @(
      "SPRING_PROFILES_ACTIVE=prod",
      "FIREBASE_SERVER_KEY=FIREBASE_SERVER_KEY_PLACEHOLDER",
      "FIREBASE_PROJECT_ID=FIREBASE_PROJECT_ID_PLACEHOLDER",
      "SENDGRID_API_KEY=SENDGRID_API_KEY_PLACEHOLDER",
      "JWT_SECRET=${JwtSecret}"
    )
  }
)

# ── Filter services if -Services specified ─────────────────

if ($Services) {
  $filter = $Services.Split(",") | ForEach-Object { $_.Trim() }
  $backendServices = $backendServices | Where-Object { $filter -contains $_.Name }
  Write-Host "Filtering to: $($backendServices.Name -join ', ')" -ForegroundColor Yellow
}

# ── Create Backend Services ────────────────────────────────

$basePayload = @{
  ownerId    = $OwnerId
  type       = "web_service"
  repo       = "github.com/LeGoober/PawFinder-App"
  branch     = "main"
  runtime    = "docker"
  rootDir    = "pawfinder-app-backend"
  plan       = "starter"
  region     = "oregon"
  healthCheckPath = "/actuator/health"
  autoDeploy = "yes"
}

foreach ($svc in $backendServices) {
  $payload = $basePayload.Clone()
  $payload.name = $svc.Name
  $payload.dockerfilePath = $svc.Dockerfile

  # Convert env var strings to Render API format
  $payload.envVars = @($svc.EnvVars | ForEach-Object {
    $parts = $_ -split "=", 2
    @{ key = $parts[0]; value = $parts[1] }
  })

  $body = $payload | ConvertTo-Json -Depth 5
  
  if ($DryRun) {
    Write-Host "[DRY RUN] Would create: $($svc.Name) (Dockerfile: $($svc.Dockerfile))" -ForegroundColor Cyan
    continue
  }

  Write-Host "Creating service: $($svc.Name)..." -ForegroundColor Cyan
  try {
    $result = Invoke-RestMethod -Method Post `
      -Uri "https://api.render.com/v1/services" `
      -Headers $headers `
      -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
      -ContentType "application/json"
    Write-Host "  ✓ Created: $($result.id)" -ForegroundColor Green
  } catch {
    if ($_.Exception.Response.StatusCode -eq 409) {
      Write-Host "  ⚠ Service already exists: $($svc.Name)" -ForegroundColor Yellow
    } else {
      Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
  }
}

# ── Create Frontend Service ────────────────────────────────

if (-not $SkipFrontend) {
  $frontendPayload = @{
    ownerId    = $OwnerId
    type       = "web_service"
    name       = "pawfinder-frontend"
    repo       = "github.com/LeGoober/PawFinder-App"
    branch     = "main"
    runtime    = "docker"
    rootDir    = "pawfinder_app_frontend"
    dockerfilePath = "Dockerfile"
    plan       = "starter"
    region     = "oregon"
    healthCheckPath = "/"
    autoDeploy = "yes"
    envVars    = @(
      @{ key = "API_BASE_URL"; value = "https://pawfinder-api-gateway.onrender.com" }
    )
  }

  $body = $frontendPayload | ConvertTo-Json -Depth 5

  if ($DryRun) {
    Write-Host "[DRY RUN] Would create: pawfinder-frontend" -ForegroundColor Cyan
  } else {
    Write-Host "Creating service: pawfinder-frontend..." -ForegroundColor Cyan
    try {
      $result = Invoke-RestMethod -Method Post `
        -Uri "https://api.render.com/v1/services" `
        -Headers $headers `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) `
        -ContentType "application/json"
      Write-Host "  ✓ Created: $($result.id)" -ForegroundColor Green
    } catch {
      if ($_.Exception.Response.StatusCode -eq 409) {
        Write-Host "  ⚠ Service already exists: pawfinder-frontend" -ForegroundColor Yellow
      } else {
        Write-Host "  ✗ Failed: $($_.Exception.Message)" -ForegroundColor Red
      }
    }
  }
}

# ── Summary ────────────────────────────────────────────────

Write-Host "`n══════════════════════════════════════════════" -ForegroundColor Magenta
if ($DryRun) {
  Write-Host "DRY RUN COMPLETE — no services were created." -ForegroundColor Yellow
  Write-Host "Remove -DryRun to actually create services." -ForegroundColor Yellow
} else {
  Write-Host "DEPLOY SCRIPT COMPLETE" -ForegroundColor Green
  Write-Host "`nNext steps:" -ForegroundColor White
  Write-Host "  1. Set sync:false env vars in Render Dashboard (Twilio, Stripe, AWS, etc.)" -ForegroundColor White
  Write-Host "  2. Enable PostGIS on pawfinder-db: CREATE EXTENSION IF NOT EXISTS postgis;" -ForegroundColor White
  Write-Host "  3. Configure Google OAuth redirects for pawfinder-frontend.onrender.com" -ForegroundColor White
  Write-Host "  4. Wait for all services to deploy (~5 min per service)" -ForegroundColor White
  Write-Host "  5. Verify: curl https://pawfinder-api-gateway.onrender.com/actuator/health" -ForegroundColor White
}
Write-Host "══════════════════════════════════════════════" -ForegroundColor Magenta
