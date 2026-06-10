# PawFinder — Start All Backend Services
# Usage: Set env vars from .env first, then run this script
#   $env:POSTGRES_URL="..."; ... ; .\start-all.ps1
#
# Or source .env manually before running.

$base = Split-Path -Parent $MyInvocation.MyCommand.Path

New-Item -ItemType Directory -Path (Join-Path $base "logs") -Force | Out-Null

$services = @(
    @{Name="alert-service"; Jar="pawfinder-alert-service\target\pawfinder-alert-service-1.0.0-SNAPSHOT.jar"},
    @{Name="auth-service"; Jar="pawfinder-auth-service\target\pawfinder-auth-service-1.0.0-SNAPSHOT.jar"},
    @{Name="messaging-service"; Jar="pawfinder-messaging-service\target\pawfinder-messaging-service-1.0.0-SNAPSHOT.jar"},
    @{Name="reward-service"; Jar="pawfinder-reward-service\target\pawfinder-reward-service-1.0.0-SNAPSHOT.jar"},
    @{Name="media-service"; Jar="pawfinder-media-service\target\pawfinder-media-service-1.0.0-SNAPSHOT.jar"},
    @{Name="analytics-service"; Jar="pawfinder-analytics-service\target\pawfinder-analytics-service-1.0.0-SNAPSHOT.jar"},
    @{Name="matching-service"; Jar="pawfinder-matching-service\target\pawfinder-matching-service-1.0.0-SNAPSHOT.jar"},
    @{Name="notification-service"; Jar="pawfinder-notification-service\target\pawfinder-notification-service-1.0.0-SNAPSHOT.jar"},
    @{Name="api-gateway"; Jar="pawfinder-api-gateway\target\pawfinder-api-gateway-1.0.0-SNAPSHOT.jar"}
)

foreach ($svc in $services) {
    $logFile = Join-Path $base "logs\$($svc.Name).log"
    $jarPath = Join-Path $base $svc.Jar
    
    if (-not (Test-Path $jarPath)) {
        Write-Host "MISSING JAR: $($svc.Name) — run 'mvn clean package -DskipTests' first" -ForegroundColor Red
        continue
    }
    
    Write-Host "Launching $($svc.Name)..." -ForegroundColor Cyan
    Start-Process java -ArgumentList "-jar", "`"$jarPath`"" -PassThru -NoNewWindow | Out-Null
}

Write-Host "All services launched. Check logs in $base\logs\" -ForegroundColor Green
Write-Host "Run 'netstat -ano | Select-String \"808\"' to verify ports." -ForegroundColor Gray
