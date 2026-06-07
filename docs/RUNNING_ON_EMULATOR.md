# PawFinder — Running on Android Emulator (Pixel)

> **Last updated:** June 2026  
> **Target:** Android Pixel Emulator (API 34+)  
> **Stack:** Flutter 3.22+ / Java 21 Spring Boot backend

---

## Prerequisites

Before running PawFinder on an emulator, ensure you have:

| Tool | Check Command | Minimum Version |
|------|--------------|-----------------|
| Flutter | `flutter --version` | 3.22.0 |
| Android Studio | Open IDE → Help → About | Hedgehog (2023.1.1+) |
| Java JDK | `java -version` | 21 LTS |
| Android SDK | Android Studio → SDK Manager | API 34+ |

Verify with `flutter doctor`:
```bash
flutter doctor
```
All checkmarks should be green. Address any warnings before proceeding.

---

## 1. Create & Configure Pixel Emulator

### Option A: Via Android Studio
1. Open **Android Studio**
2. Click **More Actions → Virtual Device Manager** (or Tools → Device Manager)
3. Click **Create Device**
4. Select **Pixel 7** (or any Pixel device) → Next
5. Download **Tiramisu (API 33)** or **UpsideDownCake (API 34)** system image → Next
6. Name: `Pixel_7_API_34` → Finish

### Option B: Via Command Line
```bash
# List available system images
sdkmanager --list | grep "system-images"

# Install API 34 image
sdkmanager "system-images;android-34;google_apis;x86_64"

# Create AVD
avdmanager create avd -n Pixel_7_API_34 -k "system-images;android-34;google_apis;x86_64" -d pixel_7
```

### Recommended AVD Settings
| Setting | Value |
|---------|-------|
| Device | Pixel 7 or Pixel 7 Pro |
| API Level | 34 (Android 14) |
| RAM | 2048 MB |
| VM Heap | 256 MB |
| Internal Storage | 4096 MB |
| Graphics | Hardware - GLES 2.0 |
| Cold Boot | ✅ Enabled (faster) |

---

## 2. Start the Emulator

```bash
# List available AVDs
emulator -list-avds

# Launch specific AVD
emulator -avd Pixel_7_API_34

# Launch with cold boot (faster startup)
emulator -avd Pixel_7_API_34 -no-snapshot-load

# Launch with GPU acceleration (Windows)
emulator -avd Pixel_7_API_34 -gpu host
```

Wait for the emulator to fully boot (lock screen appears). Verify:
```bash
adb devices
```
Output should show:
```
List of devices attached
emulator-5554   device
```

---

## 3. Start the Backend Services

PawFinder requires the Java backend running. From the backend directory:

### 3.1 Start Docker containers (database + services)
```bash
cd C:\Users\roris\Desktop\5.projects\2.java_projects\4.personal_projects\19.Paws\pawfinder-app-backend

# Start PostgreSQL, Redis, RabbitMQ, Elasticsearch
docker-compose up -d

# Verify containers are running
docker-compose ps
```

### 3.2 Start the microservices
Start each service in a separate terminal (or use IntelliJ run configurations):

```bash
cd C:\Users\roris\Desktop\5.projects\2.java_projects\4.personal_projects\19.Paws\pawfinder-app-backend

# Terminal 1: API Gateway (port 8080)
mvn -pl pawfinder-api-gateway spring-boot:run

# Terminal 2: Auth Service (port 8081)
mvn -pl pawfinder-auth-service spring-boot:run

# Terminal 3: Alert Service (port 8082)
mvn -pl pawfinder-alert-service spring-boot:run

# Terminal 4: Messaging Service (port 8083)
mvn -pl pawfinder-messaging-service spring-boot:run
```

### 3.3 Verify Backend
```bash
# Check API Gateway health
curl http://localhost:8080/actuator/health

# Check Auth Service
curl http://localhost:8081/actuator/health

# Access Swagger UI
start http://localhost:8081/swagger-ui.html
```

---

## 4. Configure Network for Emulator ↔ Backend

The Android emulator uses **10.0.2.2** to reach the host machine's localhost. This is already configured in the Flutter app:

```dart
// lib/core/constants/api_constants.dart
static const String baseUrl = 'http://10.0.2.2:8080';
static const String wsUrl = 'ws://10.0.2.2:8080/ws';
```

> ⚠️ **10.0.2.2** only works on Android emulator. For physical devices, use your computer's actual IP (e.g., `192.168.1.x`).

---

## 5. Run the Flutter App

### 5.1 Install dependencies
```bash
cd C:\Users\roris\Desktop\5.projects\2.java_projects\4.personal_projects\19.Paws\pawfinder_app_frontend

flutter pub get
```

### 5.2 Verify analysis
```bash
flutter analyze
```
Should show 0 errors (info warnings about `prefer_const_constructors` are non-blocking).

### 5.3 Launch on emulator
```bash
# First, verify emulator is detected
flutter devices

# Run in debug mode (hot reload enabled)
flutter run

# Or specify the device explicitly
flutter run -d emulator-5554
```

### 5.4 What to Expect
1. **Splash Page** — PawFinder logo on orange background, 2-second auto-transition
2. **Onboarding** — 3-page swipe guide, tap "Get Started" → Home
3. **Home Page** — Warning banner, map placeholder, 3 mock alert cards, FAB
4. **Create Alert** — 5-step wizard (Select Pet → Location → Details → Reward → Review)
5. **Alert Detail** — Pet photo, description, "I Saw This Pet" button
6. **Messages** — Chat bubbles with mock conversation
7. **Dashboard** — Stats, charts, leaderboard
8. **Profile** — User info, settings list, logout
9. **Leaderboard** — Ranked rescuers with medals

---

## 6. Hot Reload & Development Workflow

| Action | Command/Shortcut |
|--------|-----------------|
| Hot reload (preserve state) | `r` in terminal, or `Ctrl+S` in IDE |
| Hot restart (reset state) | `R` in terminal |
| Full rebuild | `flutter run` again |
| Open Dart DevTools | `v` in terminal |
| Toggle debug paint | `p` in terminal |
| Performance overlay | `P` in terminal |

---

## 7. Common Issues & Fixes

### 7.1 "No connected devices found"
```bash
# Kill and restart ADB server
adb kill-server
adb start-server

# Check emulator connection
adb devices

# If still not showing, cold boot emulator
emulator -avd Pixel_7_API_34 -no-snapshot-load
```

### 7.2 "Connection refused" when calling API
```bash
# Check backend is running
curl http://localhost:8080/actuator/health

# Verify emulator network
adb shell ping 10.0.2.2
```

### 7.3 Google Maps not rendering
The map requires a real API key. For MVP development, a placeholder is shown.
To enable maps: add your key to `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

### 7.4 "flutter: command not found"
```bash
# Add Flutter to PATH (Windows)
# Add this to your PowerShell profile:
$env:PATH += ";C:\flutter\bin"
```

### 7.5 Gradle build fails
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### 7.6 Emulator extremely slow
```bash
# Enable Hyper-V acceleration (Windows)
# Settings → Windows Features → Hyper-V + Windows Hypervisor Platform

# Or use hardware rendering
emulator -avd Pixel_7_API_34 -gpu host

# Allocate more RAM in AVD settings (2048 MB minimum)
```

---

## 8. Running Without Backend

For UI-only development (no API calls needed), the app works standalone with mock data:

```bash
cd pawfinder_app_frontend
flutter run
```

All repositories (`*_repository_impl.dart`) return mock data with simulated delays. The app is fully functional for UI development without any backend running.

---

## 9. Running on Physical Android Device

1. Enable **Developer Options** on your phone
2. Enable **USB Debugging**
3. Connect via USB
4. Verify: `adb devices` (should show your device)
5. Update `ApiConstants.baseUrl` to your computer's IP:
```dart
static const String baseUrl = 'http://192.168.1.100:8080'; // Your PC's LAN IP
```
6. Run: `flutter run`

---

## 10. Quick Start (One-Command Summary)

```bash
# Terminal 1: Start backend containers
cd pawfinder-app-backend && docker-compose up -d

# Terminal 2: Start backend services (auth + alert + messaging)
cd pawfinder-app-backend
mvn -pl pawfinder-api-gateway spring-boot:run

# Terminal 3: Start Flutter on emulator
cd pawfinder_app_frontend
flutter run
```

Then open `http://localhost:8080/swagger-ui.html` for API docs.

---

*Happy coding! 🐾*
