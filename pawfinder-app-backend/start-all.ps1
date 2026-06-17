# PawFinder - Start All Backend Services
# Loads .env automatically — no manual env var setup needed.

$base = Split-Path -Parent $MyInvocation.MyCommand.Path

# Load .env file
$envFile = Join-Path $base ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and $line -notmatch '^#') {
            $parts = $line -split '=', 2
            if ($parts.Count -eq 2) {
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                [System.Environment]::SetEnvironmentVariable($key, $value, 'Process')
            }
        }
    }
    Write-Host "Loaded .env configuration" -ForegroundColor Gray
} else {
    Write-Host "WARNING: .env file not found at $envFile" -ForegroundColor Yellow
}

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
        Write-Host "MISSING JAR: $($svc.Name) -- run 'mvn clean package -DskipTests' first" -ForegroundColor Red
        continue
    }
    
    Write-Host "Launching $($svc.Name)..." -ForegroundColor Cyan
    $args = @("-jar", $jarPath)
    Start-Process java -ArgumentList $args -PassThru -NoNewWindow | Out-Null
}

Write-Host "All services launched. Check logs in logs\" -ForegroundColor Green
Write-Host "Run 'netstat -ano | Select-String 808' to verify ports." -ForegroundColor Gray
