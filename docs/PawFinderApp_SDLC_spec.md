# PawFinder App — Software Development Life Cycle (SDLC) Documentation

> **Project:** PawFinder (Working Title)  
> **Type:** Mobile & Web Application  
> **Domain:** Community-Driven Lost Pet Recovery Platform  
> **Date:** June 2026  
> **Status:** Ideation & Requirements Phase

---

## Table of Contents
1. [Phase 1: Brainstorming & Ideation](#phase-1-brainstorming--ideation)
2. [Phase 2: Requirements Analysis](#phase-2-requirements-analysis)
3. [Phase 3: System Design](#phase-3-system-design)
4. [Phase 4: UI/UX Design](#phase-4-uiux-design)
5. [Phase 5: Development Plan](#phase-5-development-plan)
6. [Phase 6: Testing Strategy](#phase-6-testing-strategy)
7. [Phase 7: Deployment & Launch](#phase-7-deployment--launch)
8. [Phase 8: Maintenance & Iteration](#phase-8-maintenance--iteration)
9. [Appendices](#appendices)

---

## Phase 1: Brainstorming & Ideation

### 1.1 Problem Statement
Every year, millions of pets go missing worldwide. Current recovery methods are fragmented, rely heavily on physical posters, social media luck, and word-of-mouth. There is no unified, privacy-first, community-powered platform specifically designed to reunite lost pets with their owners while protecting both parties.

### 1.2 Core Insight
The emotional urgency of a lost pet creates immediate community willingness to help, but existing solutions fail because:
- **Privacy risks:** Posters expose phone numbers and home addresses
- **Fragmentation:** Information scattered across Facebook groups, shelters, and physical flyers
- **No verification:** Anyone can claim they found a pet, leading to scams or false hope
- **No incentive structure:** Helpers rarely get recognized or rewarded
- **Alert fatigue:** Social media posts get buried quickly

### 1.3 Brand Identity Evolution

| Direction | Names Explored | Rationale |
|-----------|---------------|-----------|
| Heartfelt & Emotional | PawPrints, FurEver Home, WhiskerWatch | Emphasizes emotional bond and reunion |
| Search & Rescue | PetRadar, TailTracker, FindMyFur | Direct, functional, tech-forward |
| Community & Connection | Lost & Found Paws, PetLink, GuardianPaws | Highlights collective action |
| Short & Catchy | Snout, Fetch, PawPal | Memorable, brandable, app-store friendly |

**Selected Direction:** *Paw* as the root word (PawFinder, PawAlert, PawLink) — versatile, warm, and allows for iterative branding (PawFinder AI, PawFinder Pro, etc.).

### 1.4 Value Proposition
> **"A privacy-first, community-powered network that turns every neighbor into a potential hero — reuniting lost pets with their families safely, quickly, and transparently."**

### 1.5 Key Differentiators
1. **Anonymous Alerts:** Owners never expose personal contact information
2. **Verified Pings:** Location-based, rate-limited, verified alerts prevent spam
3. **Reward Mechanics:** Built-in reward system with escrow-like trust
4. **Live Metrics:** Public dashboard showing active missing vs. found cases
5. **Shelter Integration:** Direct API connections to local shelters and vet clinics
6. **QR Collar Integration:** Physical-digital bridge for instant identification

---

## Phase 2: Requirements Analysis

### 2.1 Functional Requirements

#### FR-001: Anonymous Alert System ("Pings")
- **FR-001.1:** Users can create a "Missing Pet Alert" with photo, description, last seen location, and timestamp
- **FR-001.2:** Owner identity (name, phone, email) is NEVER displayed publicly
- **FR-001.3:** Alerts are geofenced and broadcast to users within a configurable radius (default: 2km, expandable)
- **FR-001.4:** Alerts include species, breed, color, size, distinguishing features, and temperament notes
- **FR-001.5:** Alerts auto-expire after 30 days unless renewed by owner
- **FR-001.6:** Rate limit: maximum 3 active alerts per user to prevent abuse

#### FR-002: Finder Notification System
- **FR-002.1:** Any user who spots a missing pet can tap "I Found This Pet" on the alert
- **FR-002.2:** System initiates a secure, in-app messaging channel between finder and owner
- **FR-002.3:** Owner receives push notification + email when a potential match is reported
- **FR-002.4:** Finder can upload photos and location pins to verify the sighting
- **FR-002.5:** Owner can mark case as "Resolved" which archives the conversation and updates metrics

#### FR-003: Active Dashboard ("PawMap")
- **FR-003.1:** Map view showing all active missing pets in user's current area
- **FR-003.2:** List view with filters: species, date missing, distance, reward offered
- **FR-003.3:** Real-time metrics panel: Active Cases, Resolved Cases (Today/Week/Month), Avg. Resolution Time
- **FR-003.4:** Heat map layer showing high-activity zones
- **FR-003.5:** Users can subscribe to neighborhood-specific push notifications

#### FR-004: Reward System
- **FR-004.1:** Owners can attach a monetary reward to an alert (optional)
- **FR-004.2:** Reward amount is displayed publicly; payment details are not
- **FR-004.3:** Upon resolution, owner confirms payout through integrated payment gateway (Stripe/PayPal)
- **FR-004.4:** Platform takes 5-10% transaction fee to sustain operations
- **FR-004.5:** Non-monetary rewards supported: gift cards, donations to shelter in finder's name

#### FR-005: Verification & Trust Layer
- **FR-005.1:** New accounts must verify phone number via SMS
- **FR-005.2:** "Verified Rescuer" badge for users who have successfully reunited 3+ pets
- **FR-005.3:** Photo verification: uploaded pet photos are hashed and checked against known scam databases
- **FR-005.4:** Shelter/Vet partner accounts get blue verification badge
- **FR-005.5:** Report spam/abuse functionality on every alert and message
- **FR-005.6:** AI moderation on messages to detect harassment or fraud attempts

#### FR-006: Community Engagement & Gamification
- **FR-006.1:** Badge system: Neighborhood Hero, Pet Detective, Shelter Angel, Fast Responder
- **FR-006.2:** Leaderboard: monthly top finders by region
- **FR-006.3:** "Share Alert" functionality to external social media (preserves anonymity)
- **FR-006.4:** Community feed showing recent success stories (with owner consent)
- **FR-006.5:** Push notifications for new alerts within user-defined radius and species preferences

#### FR-007: Shelter & Vet Integration
- **FR-007.1:** Partner portal for shelters/vets to upload found pets
- **FR-007.2:** Auto-matching algorithm compares shelter intakes against active missing alerts
- **FR-007.3:** API for shelter management systems (PetPoint, Shelterluv, etc.)
- **FR-007.4:** Automated notification to owners when a potential match is found at a partner facility

#### FR-008: QR Collar Integration (Future Phase)
- **FR-008.1:** Users can generate a unique QR code linked to their pet's profile
- **FR-008.2:** QR code can be printed on collar tags or engraved plates
- **FR-008.3:** Scanning QR sends instant notification to owner with finder's location (if GPS enabled)
- **FR-008.4:** QR profile shows pet's name, medical needs, and emergency contact (optional)

### 2.2 Non-Functional Requirements

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-001 | Privacy Compliance | GDPR, CCPA compliant; data encrypted at rest and in transit |
| NFR-002 | Performance | Alert creation < 2s; Map load < 3s; Push notification < 5s |
| NFR-003 | Availability | 99.9% uptime; critical path (alerts/messaging) has redundancy |
| NFR-004 | Scalability | Support 100k concurrent users; 10k alerts/day at launch |
| NFR-005 | Security | OWASP Top 10 mitigation; penetration testing before launch |
| NFR-006 | Accessibility | WCAG 2.1 AA compliance; screen reader support |
| NFR-007 | Localization | English (launch), Spanish and French (Phase 2) |
| NFR-008 | Battery Efficiency | Background geolocation optimized; max 5% battery drain/day |

### 2.3 User Personas

#### Persona 1: "Stressed Sarah" — Pet Owner
- **Demographics:** 28-45, urban/suburban, dog/cat owner
- **Pain Point:** Pet escaped during a storm; panicked; doesn't want phone number on public posters
- **Goal:** Find pet quickly without exposing personal information to strangers
- **Tech Comfort:** High; uses apps daily

#### Persona 2: "Helpful Hank" — Community Member
- **Demographics:** 35-60, neighborhood watch member, retired or flexible schedule
- **Pain Point:** Sees lost pet posters but forgets details; wants to help but doesn't know how
- **Goal:** Be notified of missing pets nearby and easily report sightings
- **Tech Comfort:** Medium; uses Facebook and basic apps

#### Persona 3: "Busy Bella" — Shelter Volunteer
- **Demographics:** 22-40, works at animal shelter, manages intake records
- **Pain Point:** Manual cross-referencing of lost reports against found animals
- **Goal:** Automate matching and reduce time-to-reunion
- **Tech Comfort:** High; uses shelter management software daily

### 2.4 User Stories

**US-001:** *As a pet owner, I want to post an alert without showing my phone number, so that I can protect my privacy while still getting help.*

**US-002:** *As a community member, I want to see missing pets near my current location, so that I can keep an eye out during my daily routine.*

**US-003:** *As a finder, I want to message the owner securely through the app, so that I can coordinate returning the pet without exposing either party's contact info.*

**US-004:** *As a shelter worker, I want to upload a found pet and automatically match it against active alerts, so that I can reunite pets faster.*

**US-005:** *As a helper, I want to earn recognition and rewards, so that I feel motivated to participate actively in the community.*

---

## Phase 3: System Design

### 3.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      CLIENT LAYER                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │  iOS App     │  │  Android App │  │  Web App     │      │
│  │  (Flutter)   │  │  (Flutter)   │  │  (Flutter Web│      │
│  │              │  │              │  │   or React)  │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      API GATEWAY (AWS/GCP)                  │
│  • Rate Limiting  • Auth (JWT)  • SSL Termination  • WAF    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER (Java)                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Alert Svc    │  │ Messaging Svc│  │ Matching Svc │      │
│  │ (Spring Boot)│  │ (Spring Boot)│  │ (Spring Boot)│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Reward Svc   │  │ Notif Svc    │  │ Analytics Svc│      │
│  │ (Spring Boot)│  │ (Spring Boot)│  │ (Spring Boot)│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │ Auth Svc     │  │ Media Svc    │                         │
│  │ (Spring Boot)│  │ (Spring Boot)│                         │
│  └──────────────┘  └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ PostgreSQL   │  │ Redis        │  │ S3/CloudStor │      │
│  │ (Primary DB) │  │ (Cache/Sess) │  │ (Images)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Elasticsearch│  │ RabbitMQ     │  │ Firebase FCM │      │
│  │ (Search/Geo) │  │ (Message Q)  │  │ (Push Notif) │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   THIRD-PARTY INTEGRATIONS                  │
│  • Stripe/PayPal (Payments)  • Twilio (SMS)                │
│  • Google Maps (Geolocation)   • Shelter APIs              │
│  • SendGrid (Email)            • AWS Rekognition (Image AI)│
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Technology Stack (Java + Flutter)

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **Mobile** | Flutter (Dart) | Single codebase for iOS/Android; native performance; rich widget ecosystem; excellent map support via `google_maps_flutter` |
| **Web** | Flutter Web (PWA) OR Next.js | Flutter Web for unified codebase; Next.js fallback for SEO-heavy landing pages |
| **Backend** | Java 21 + Spring Boot 3.2 | Enterprise-grade; robust ecosystem; excellent for microservices; strong typing; vast library support |
| **Database** | PostgreSQL 15 + PostGIS | ACID compliance; native geospatial queries; excellent Spring Data JPA support |
| **Cache** | Redis | Spring Session support; rate limiting; real-time pub/sub for WebSocket fallback |
| **Message Queue** | RabbitMQ | Reliable message delivery; Spring AMQP integration; dead-letter queues for retry logic |
| **Search** | Elasticsearch | Spring Data Elasticsearch; full-text pet search; geo-distance queries |
| **Storage** | AWS S3 + CloudFront | Spring Cloud AWS integration; image CDN |
| **Auth** | Spring Security + JWT + Firebase Auth | OAuth2 resource server; custom JWT filters; phone verification via Twilio |
| **Push** | Firebase Cloud Messaging | `firebase_messaging` Flutter plugin; cross-platform; reliable |
| **Maps** | Google Maps Platform + `flutter_map` (Mapbox) | Native Google Maps on mobile; Mapbox for web/custom styling |
| **Payments** | Stripe Java SDK | Marketplace payments; escrow-like hold; split payments |
| **AI/ML** | AWS Rekognition + Spring Integration | Pet breed classification; image similarity; scam detection |
| **Hosting** | AWS ECS (Fargate) OR Kubernetes (EKS) | Spring Boot Docker containers; auto-scaling; managed |
| **CI/CD** | GitHub Actions → ECR → ECS | Automated Maven builds; container deployment |
| **Monitoring** | Spring Boot Actuator + Micrometer + Datadog | Health checks; metrics; distributed tracing |
| **API Docs** | SpringDoc OpenAPI (Swagger) | Auto-generated API documentation; Flutter code generation potential |

### 3.3 Backend Architecture (Spring Boot)

```java
// Service Structure
com.pawfinder
├── api-gateway/          // Spring Cloud Gateway (routing, rate limiting, auth)
├── auth-service/         // OAuth2, JWT, phone verification
├── alert-service/        // CRUD for alerts, geospatial queries
├── messaging-service/    // WebSocket (STOMP), chat persistence
├── matching-service/     // Shelter intake matching, AI similarity
├── reward-service/       // Stripe integration, reward lifecycle
├── notification-service/ // Push, SMS, email orchestration
├── media-service/        // Image upload, processing, CDN
├── analytics-service/    // Metrics aggregation, reporting
└── shared/
    ├── domain/           // Common entities, DTOs
    ├── events/           // RabbitMQ event definitions
    └── security/         // JWT utilities, encryption
```

### 3.4 Database Schema (Core Tables)

```sql
-- Users (Anonymized Core)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    auth_provider VARCHAR(50), -- google, apple, email
    auth_id VARCHAR(255) UNIQUE, -- external auth ID
    phone_hash VARCHAR(255), -- hashed for verification
    email_hash VARCHAR(255), -- hashed for notifications
    display_name VARCHAR(100), -- optional public alias
    verified BOOLEAN DEFAULT FALSE,
    rescuer_badge_level INT DEFAULT 0, -- 0=none, 1=bronze, 2=silver, 3=gold
    created_at TIMESTAMP DEFAULT NOW(),
    last_active TIMESTAMP
);

-- Pets (Owner's Pet Profiles)
CREATE TABLE pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100),
    species VARCHAR(50), -- dog, cat, bird, etc.
    breed VARCHAR(100),
    color VARCHAR(100),
    size VARCHAR(20), -- small, medium, large
    distinguishing_features TEXT,
    temperament_notes TEXT,
    medical_needs TEXT,
    photos JSONB, -- array of S3 URLs
    qr_code_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Alerts (Missing Pet Reports)
CREATE TABLE alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID REFERENCES pets(id),
    owner_id UUID REFERENCES users(id),
    status VARCHAR(20) DEFAULT 'active', -- active, resolved, expired, cancelled
    last_seen_location GEOGRAPHY(POINT, 4326),
    last_seen_address TEXT,
    last_seen_timestamp TIMESTAMP,
    description TEXT,
    reward_amount DECIMAL(10,2),
    reward_currency VARCHAR(3) DEFAULT 'USD',
    reward_claimed BOOLEAN DEFAULT FALSE,
    geofence_radius_km INT DEFAULT 2,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP DEFAULT NOW() + INTERVAL '30 days',
    resolved_at TIMESTAMP
);

-- Sightings (Finder Reports)
CREATE TABLE sightings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_id UUID REFERENCES alerts(id),
    finder_id UUID REFERENCES users(id),
    location GEOGRAPHY(POINT, 4326),
    photo_urls JSONB,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'pending', -- pending, confirmed, rejected
    created_at TIMESTAMP DEFAULT NOW()
);

-- Conversations (Secure Messaging)
CREATE TABLE conversations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_id UUID REFERENCES alerts(id),
    owner_id UUID REFERENCES users(id),
    finder_id UUID REFERENCES users(id),
    sighting_id UUID REFERENCES sightings(id),
    status VARCHAR(20) DEFAULT 'open', -- open, closed, reported
    created_at TIMESTAMP DEFAULT NOW(),
    closed_at TIMESTAMP
);

-- Messages
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    conversation_id UUID REFERENCES conversations(id),
    sender_id UUID REFERENCES users(id),
    content TEXT,
    content_type VARCHAR(20) DEFAULT 'text', -- text, image, location
    created_at TIMESTAMP DEFAULT NOW(),
    read_at TIMESTAMP
);

-- Metrics (Time-Series Aggregations)
CREATE TABLE daily_metrics (
    date DATE PRIMARY KEY,
    active_alerts INT DEFAULT 0,
    new_alerts INT DEFAULT 0,
    resolved_alerts INT DEFAULT 0,
    avg_resolution_hours DECIMAL(8,2),
    total_rewards_offered DECIMAL(12,2),
    total_rewards_claimed DECIMAL(12,2),
    new_users INT DEFAULT 0,
    active_users INT DEFAULT 0
);
```

### 3.5 API Design (REST + WebSocket)

#### Core Endpoints

```
POST   /api/v1/auth/register          → Register with phone/email
POST   /api/v1/auth/verify            → SMS verification
POST   /api/v1/auth/login             → OAuth2 / JWT login
POST   /api/v1/auth/refresh           → Refresh JWT token

GET    /api/v1/pets                   → List user's pets
POST   /api/v1/pets                   → Create pet profile
GET    /api/v1/pets/:id               → Get pet details
PUT    /api/v1/pets/:id               → Update pet profile
DELETE /api/v1/pets/:id               → Delete pet profile

POST   /api/v1/alerts                 → Create missing pet alert
GET    /api/v1/alerts/nearby          → Get alerts near location (lat, lng, radius)
GET    /api/v1/alerts/:id             → Get alert details (anonymized owner)
PUT    /api/v1/alerts/:id/resolve     → Mark as resolved
DELETE /api/v1/alerts/:id             → Cancel alert
POST   /api/v1/alerts/:id/boost       → Boost alert visibility (premium)

POST   /api/v1/sightings              → Report a sighting
GET    /api/v1/sightings/:id          → Get sighting details
PUT    /api/v1/sightings/:id/confirm  → Owner confirms sighting
PUT    /api/v1/sightings/:id/reject   → Owner rejects sighting

POST   /api/v1/conversations          → Start conversation (owner↔finder)
GET    /api/v1/conversations          → List user's conversations
GET    /api/v1/conversations/:id/messages → Get messages (paginated)
POST   /api/v1/conversations/:id/messages → Send message
PUT    /api/v1/conversations/:id/close → Close conversation

GET    /api/v1/dashboard/metrics      → Public metrics (active, resolved, avg time)
GET    /api/v1/dashboard/heatmap      → Alert density heatmap data
GET    /api/v1/leaderboard            → Top rescuers by region
GET    /api/v1/badges                → Available badges and user progress

POST   /api/v1/rewards/:id/claim      → Initiate reward claim
POST   /api/v1/rewards/:id/confirm    → Owner confirms reward release
GET    /api/v1/rewards/:id/status     → Check reward status
```

#### WebSocket Events (STOMP over SockJS)
```javascript
// WebSocket endpoint: /ws
// STOMP destinations:

// Subscribe:
/user/queue/alerts              → New alerts in user's area
/user/queue/sightings           → New sighting on user's alert
/user/queue/messages            → New message in conversation
/user/queue/rewards             → Reward status updates
/topic/community/:regionId      → Regional community updates

// Send:
/app/chat.send                  → Send chat message
/app/sighting.report            → Report sighting (real-time)
```

### 3.6 Privacy & Security Architecture

```
┌────────────────────────────────────────────┐
│         PRIVACY BY DESIGN PRINCIPLES        │
├────────────────────────────────────────────┤
│ 1. Data Minimization                         │
│    • Store only hashed emails/phones         │
│    • No real names in public alerts          │
│    • Location fuzzing (±100m by default)     │
│                                              │
│ 2. Purpose Limitation                        │
│    • Pet photos used ONLY for identification │
│    • Messages auto-deleted after 90 days     │
│    • Location history purged after resolution│
│                                              │
│ 3. User Control                              │
│    • One-click data export (GDPR)           │
│    • One-click account deletion              │
│    • Granular notification preferences       │
│                                              │
│ 4. Encryption                                │
│    • TLS 1.3 for all transit                 │
│    • AES-256 for data at rest                │
│    • End-to-end encryption for messages      │
│                                              │
│ 5. Access Control                            │
│    • Role-based access (RBAC)                │
│    • Spring Security method-level security     │
│    • Audit logs for all admin actions        │
│    • IP-based rate limiting (Bucket4j)       │
└────────────────────────────────────────────┘
```

### 3.7 Flutter Project Structure

```
lib/
├── main.dart                    // Entry point, app initialization
├── app.dart                     // MaterialApp configuration, routing
├── core/
│   ├── constants/               // App constants, API endpoints
│   ├── theme/                   // ThemeData, colors, typography
│   ├── utils/                   // Extensions, helpers, validators
│   ├── errors/                  // Exception classes, error handlers
│   └── usecases/                // Base use case abstraction
├── data/
│   ├── models/                  // JSON-serializable data models
│   ├── repositories/            // Repository implementations
│   ├── datasources/
│   │   ├── remote/              // API clients (Dio), WebSocket
│   │   ├── local/               // Hive/SharedPreferences
│   │   └── cache/               // In-memory cache
│   └── mappers/                 // Domain ↔ Data model mappers
├── domain/
│   ├── entities/                // Pure business objects
│   ├── repositories/            // Repository interfaces
│   └── usecases/                // Business logic operations
├── presentation/
│   ├── blocs/                   // BLoC/Cubit state management
│   ├── pages/                   // Screen-level widgets
│   ├── widgets/                 // Reusable UI components
│   └── routes/                  // GoRouter configuration
├── services/
│   ├── location_service.dart    // Geolocation, geofencing
│   ├── notification_service.dart // FCM, local notifications
│   ├── auth_service.dart        // Authentication state
│   └── analytics_service.dart   // Firebase/Mixpanel
└── di/
    └── injection.dart           // GetIt dependency injection
```

---

## Phase 4: UI/UX Design

### 4.1 Information Architecture

```
PawFinder App
├── Onboarding
│   ├── Welcome & Value Proposition
│   ├── Permission Requests (Location, Notifications, Camera)
│   └── Account Setup (OAuth or Phone)
│
├── Home (Dashboard)
│   ├── Map View (Active Alerts Nearby)
│   ├── List View (Filtered Alerts)
│   ├── Quick Stats (Active/Resolved/Your Impact)
│   └── Recent Activity Feed
│
├── Alerts
│   ├── Create Alert (Step-by-Step Wizard)
│   ├── My Alerts (Active & Resolved)
│   ├── Alert Detail (Anonymized)
│   └── Share Alert (Social Media)
│
├── Find & Report
│   ├── Scan Area (Camera + AI Match)
│   ├── Report Sighting (Photo + Location)
│   └── My Sightings (History)
│
├── Messages
│   ├── Conversation List
│   ├── Chat Interface (In-App)
│   └── Safety Tips
│
├── Community
│   ├── Leaderboard
│   ├── Success Stories
│   ├── Badges & Achievements
│   └── Neighborhood Stats
│
├── Profile
│   ├── My Pets
│   ├── Account Settings
│   ├── Notification Preferences
│   ├── Privacy Controls
│   └── Help & Support
│
└── Shelter Portal (Partner View)
    ├── Intake Upload
    ├── Auto-Match Results
    └── Reunion Tracking
```

### 4.2 Key Screen Specifications

#### Screen 1: Home Dashboard (Primary Screen)
- **Top Bar:** Location pill ("Downtown Seattle • 2km radius") + Notification bell
- **Hero Section:** "3 pets missing near you" with urgency indicator
- **Map View:** Interactive map with custom pet icons (🐕 🐈 🦜) clustered by density
- **Bottom Sheet:** Draggable list of nearest alerts with photo, species, time missing, distance, reward badge
- **FAB (Floating Action Button):** "+ Report Missing Pet" (red, prominent)
- **Secondary FAB:** "I Found a Pet" (green)

#### Screen 2: Create Alert (Wizard)
- **Step 1:** Select pet from profile (or create new)
- **Step 2:** Confirm last seen location (map pin + address search)
- **Step 3:** Add details (when, circumstances, temperament when scared)
- **Step 4:** Set reward (optional, with suggested ranges)
- **Step 5:** Review & Submit (privacy reminder: "Your contact info stays hidden")
- **Success State:** Alert live + share options + "Boost Alert" (premium feature)

#### Screen 3: Alert Detail (Community View)
- **Header:** Pet photo carousel, species badge, time missing
- **Info Card:** Description, distinguishing features, last known location (fuzzed)
- **Action Bar:** "I Saw This Pet" button + "Share" + "Save"
- **Safety Banner:** "Never send money upfront. Rewards are handled in-app."
- **Owner View (if owner):** Edit, boost, view sightings, resolve

#### Screen 4: Secure Messaging
- **Header:** "Conversation about [Pet Name]" + case status
- **Chat Bubble:** Standard messaging UI with image support
- **Safety Footer:** "Your phone number and email are hidden. Stay in-app."
- **Action Sheet:** Share location, suggest meetup point, mark as resolved

#### Screen 5: Metrics Dashboard (Public)
- **Hero Numbers:** Active cases today, Resolved this week, Avg. find time
- **Trend Graph:** 7-day line chart of alerts vs. resolutions
- **Regional Breakdown:** Bar chart by neighborhood
- **Impact Counter:** "1,247 pets reunited since launch"
- **Live Feed:** Recent success stories (anonymized, with consent)

### 4.3 Design System

```css
/* Color Palette */
--primary: #FF6B35;        /* Warm Orange - Urgency & Action */
--primary-dark: #E55A2B;   /* Darker Orange - Pressed States */
--secondary: #4ECDC4;      /* Teal - Trust & Safety */
--accent: #FFE66D;         /* Yellow - Rewards & Highlights */
--success: #2ECC71;        /* Green - Resolved / Found */
--danger: #E74C3C;         /* Red - Missing / Urgent */
--neutral-900: #1A1A2E;    /* Near Black - Text */
--neutral-100: #F7F7F9;    /* Off White - Backgrounds */

/* Typography */
--font-heading: 'Inter', sans-serif;  /* Bold, clean, modern */
--font-body: 'Inter', sans-serif;     /* Highly readable */
--font-size-hero: 32px;
--font-size-h1: 24px;
--font-size-body: 16px;
--font-size-caption: 12px;

/* Spacing & Shape */
--radius-sm: 8px;
--radius-md: 12px;
--radius-lg: 16px;
--radius-pill: 999px;
--shadow-card: 0 2px 8px rgba(0,0,0,0.08);
--shadow-float: 0 4px 16px rgba(0,0,0,0.12);
```

### 4.4 User Flow Diagrams

#### Flow 1: Owner Posts Alert → Pet is Found
```
[Owner Opens App] → [Tap "+ Report Missing Pet"]
    ↓
[Select Pet Profile] → [Set Last Location] → [Add Details]
    ↓
[Set Reward (Optional)] → [Submit Alert]
    ↓
[System Broadcasts to 2km Radius] → [Push Notifications Sent]
    ↓
[Community Member Sees Alert] → [Spots Pet] → [Taps "I Saw This Pet"]
    ↓
[Uploads Photo + Location] → [Owner Gets Notification]
    ↓
[Owner Opens Secure Chat] → [Coordinates Meetup]
    ↓
[Pet Reunited] → [Owner Marks Resolved] → [Reward Released (if set)]
    ↓
[Success Story Prompt] → [Badge Awarded to Finder] → [Metrics Updated]
```

#### Flow 2: Community Member Discovers App
```
[User Downloads App] → [Onboarding: "Help Reunite Pets in Your Neighborhood"]
    ↓
[Grant Location Permission] → [Sees Map of Active Alerts Nearby]
    ↓
[Taps Alert] → [Views Details] → [Decides to Help]
    ↓
[Shares to Instagram Story] → [Keeps Eye Out During Walk]
    ↓
[Spots Pet] → [Opens App] → [Reports Sighting with Photo]
    ↓
[Owner Confirms] → [Chat Opens] → [Coordinates Return]
    ↓
[Receives "Neighborhood Hero" Badge + Reward]
    ↓
[Leaderboard Updated] → [User Shares Achievement] → [Viral Loop]
```

---

## Phase 5: Development Plan

### 5.1 Technology Stack (Updated: Java + Flutter)

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| **Mobile** | Flutter 3.22 (Dart) | Single codebase for iOS/Android; native performance; rich widget ecosystem; `google_maps_flutter`, `flutter_bloc`, `dio` |
| **Web** | Flutter Web (PWA) | Unified codebase with mobile; good for dashboard/shelter portal; fallback to React for SEO landing pages if needed |
| **Backend** | Java 21 LTS + Spring Boot 3.2 | Enterprise-grade; robust ecosystem; excellent for microservices; Spring Security, Spring Data, Spring Cloud |
| **Database** | PostgreSQL 15 + PostGIS | ACID compliance; native geospatial queries; excellent Spring Data JPA support |
| **Cache** | Redis | Spring Session support; rate limiting with Bucket4j; pub/sub |
| **Message Queue** | RabbitMQ | Spring AMQP; reliable delivery; dead-letter queues |
| **Search** | Elasticsearch 8.x | Spring Data Elasticsearch; full-text + geo queries |
| **Storage** | AWS S3 + CloudFront | Spring Cloud AWS; image CDN |
| **Auth** | Spring Security 6 + JWT + Firebase Auth | OAuth2 resource server; phone verification via Twilio |
| **Push** | Firebase Cloud Messaging | `firebase_messaging` Flutter plugin; cross-platform |
| **Maps** | Google Maps Platform + `flutter_map` | Native Google Maps on mobile; Mapbox for web/custom styling |
| **Payments** | Stripe Java SDK 24.x | Marketplace payments; Connect for split payments |
| **AI/ML** | AWS Rekognition + Spring Integration | Image analysis; scam detection |
| **Hosting** | AWS ECS (Fargate) | Spring Boot Docker containers; auto-scaling |
| **CI/CD** | GitHub Actions → ECR → ECS | Maven builds; container deployment |
| **Monitoring** | Spring Boot Actuator + Micrometer + Datadog | Health checks; metrics; distributed tracing |
| **API Docs** | SpringDoc OpenAPI 2.3 | Auto-generated Swagger UI; potential for Flutter code generation |

### 5.2 Flutter Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.5
  equatable: ^2.0.5

  # Networking
  dio: ^5.4.0
  retrofit: ^4.1.0

  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2

  # Maps & Location
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  flutter_map: ^6.1.0
  latlong2: ^0.9.0

  # Notifications
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.3.0

  # Auth
  firebase_auth: ^4.16.0
  google_sign_in: ^6.2.0
  sign_in_with_apple: ^5.0.0

  # UI Components
  flutter_screenutil: ^5.9.0
  shimmer: ^3.0.0
  cached_network_image: ^3.3.0
  image_picker: ^1.0.7
  photo_view: ^0.14.0

  # Utilities
  intl: ^0.19.0
  uuid: ^4.3.0
  permission_handler: ^11.1.0
  url_launcher: ^6.2.0
  share_plus: ^7.2.0

  # Payments
  flutter_stripe: ^9.6.0

  # Analytics
  firebase_analytics: ^10.8.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.8
  retrofit_generator: ^8.1.0
  hive_generator: ^2.0.1
  json_serializable: ^6.7.1
  flutter_lints: ^3.0.0
```

### 5.3 Spring Boot Dependencies (pom.xml)

```xml
<dependencies>
    <!-- Spring Boot Starters -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-websocket</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-amqp</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>

    <!-- Spring Cloud -->
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-gateway</artifactId>
    </dependency>

    <!-- Database -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
    </dependency>
    <dependency>
        <groupId>org.hibernate.orm</groupId>
        <artifactId>hibernate-spatial</artifactId>
    </dependency>

    <!-- Elasticsearch -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
    </dependency>

    <!-- Security -->
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-api</artifactId>
    </dependency>
    <dependency>
        <groupId>com.bucket4j</groupId>
        <artifactId>bucket4j-core</artifactId>
    </dependency>

    <!-- AWS -->
    <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>s3</artifactId>
    </dependency>
    <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>rekognition</artifactId>
    </dependency>

    <!-- Third Party -->
    <dependency>
        <groupId>com.stripe</groupId>
        <artifactId>stripe-java</artifactId>
    </dependency>
    <dependency>
        <groupId>com.twilio.sdk</groupId>
        <artifactId>twilio</artifactId>
    </dependency>
    <dependency>
        <groupId>com.sendgrid</groupId>
        <artifactId>sendgrid-java</artifactId>
    </dependency>

    <!-- API Docs -->
    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    </dependency>

    <!-- Testing -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.testcontainers</groupId>
        <artifactId>testcontainers</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### 5.4 Sprint Breakdown (MVP: 14 Weeks)

#### Sprint 1-2: Foundation (Weeks 1-2)
- [ ] Project scaffolding (Mono-repo: Flutter, Java multi-module)
- [ ] Database schema implementation + Flyway migrations
- [ ] Spring Boot API Gateway + Auth service setup
- [ ] Flutter project setup with BLoC, Dio, dependency injection
- [ ] CI/CD pipeline (GitHub Actions: Maven + Flutter builds)
- [ ] Design system component library (Flutter Storybook)

#### Sprint 3-4: Core Backend (Weeks 3-4)
- [ ] User service (OAuth + phone verification with Twilio)
- [ ] Pet profile CRUD with image upload to S3
- [ ] Alert service with PostGIS geospatial queries
- [ ] Basic REST API documentation (SpringDoc)
- [ ] Flutter auth flow (login/register/verification)

#### Sprint 5-6: Core Mobile (Weeks 5-6)
- [ ] Home dashboard with map view (`google_maps_flutter`)
- [ ] Alert creation wizard (5-step flow)
- [ ] Nearby alerts feed (list + map views)
- [ ] Push notification setup (FCM + local notifications)
- [ ] Basic filtering (species, distance, time)

#### Sprint 7-8: Discovery & Reporting (Weeks 7-8)
- [ ] Alert detail screen (anonymized)
- [ ] Sighting report flow (camera + location)
- [ ] Share functionality (deep links)
- [ ] Backend: Sighting service + confirmation workflow
- [ ] Flutter: My sightings history

#### Sprint 9-10: Messaging & Resolution (Weeks 9-10)
- [ ] Spring WebSocket (STOMP) setup for real-time chat
- [ ] Conversation and message services
- [ ] Flutter chat interface (WebSocket client)
- [ ] Alert resolution workflow
- [ ] Reward setup UI (Flutter) + backend API

#### Sprint 11-12: Trust & Engagement (Weeks 11-12)
- [ ] Verification system (SMS, photo AI checks with Rekognition)
- [ ] Rate limiting (Bucket4j, max 3 alerts/user)
- [ ] Badge system framework + leaderboard
- [ ] Report/abuse functionality
- [ ] Admin moderation dashboard (Flutter Web or React)

#### Sprint 13-14: Payments & Launch Prep (Weeks 13-14)
- [ ] Stripe Connect integration (Java SDK)
- [ ] Reward claim and release flow (escrow logic)
- [ ] Public metrics dashboard (Flutter Web)
- [ ] Performance optimization (image caching, query optimization)
- [ ] Security audit (penetration test, OWASP ZAP)
- [ ] App store submission (iOS + Android)
- [ ] Landing page (Flutter Web or Next.js)
- [ ] Beta testing with 100 users

### 5.5 Post-MVP Roadmap

| Quarter | Features |
|-----------|----------|
| **Q2** | Shelter partner portal (Flutter Web); API integrations; QR collar generation |
| **Q3** | AI image matching (Rekognition Custom Labels); predictive heatmaps; premium subscriptions |
| **Q4** | International expansion (ES/FR); wearable GPS integration; insurance partnerships |
| **Year 2** | Microchip registry integration; drone search partnerships; AR "pet vision" overlay |

---

## Phase 6: Testing Strategy

### 6.1 Testing Pyramid

```
         ┌─────────────┐
         │   E2E Tests │  (10%) → Patrol (Flutter), Playwright (Web)
         │  User Journeys│
         ├─────────────┤
         │  Integration │  (20%) → Spring Boot Testcontainers, API contract testing
         │    Tests     │
         ├─────────────┤
         │   Unit Tests │  (70%) → JUnit 5 (Java), flutter_test (Dart)
         └─────────────┘
```

### 6.2 Critical Test Scenarios

#### Privacy & Security Tests
- **T-001:** Verify owner email/phone NEVER appears in API response for public alert endpoints
- **T-002:** Verify message content is encrypted in database
- **T-003:** Attempt to access another user's conversation → expect 403 Forbidden
- **T-004:** Rate limit test: attempt 4th alert creation → expect 429 Too Many Requests
- **T-005:** SQL injection attempt in pet description → expect sanitized input

#### Geolocation Tests
- **T-006:** Alert created at Point A → user at Point B (3km away) → should NOT receive notification
- **T-007:** Alert created at Point A → user at Point B (1km away) → SHOULD receive notification
- **T-008:** Location fuzzing test: verify coordinates in public API are ±100m offset

#### Business Logic Tests
- **T-009:** Create alert → report sighting → confirm → verify reward transfer to finder
- **T-010:** Create alert → 30 days pass → verify auto-expiration and archival
- **T-011:** Report sighting with AI-detected stock photo → verify scam flag and admin review

#### Performance Tests
- **T-012:** Load test: 10,000 concurrent users fetching nearby alerts → p95 < 500ms
- **T-013:** Load test: 1,000 alerts created simultaneously → no duplicate notifications
- **T-014:** Map render test: 500 pins on screen → maintain 60fps (Flutter profile mode)

### 6.3 QA Environments

| Environment | Purpose | Data |
|-------------|---------|------|
| `local` | Developer testing | Seeded fake data (Testcontainers) |
| `dev` | Feature branch testing | Synthetic data |
| `staging` | Pre-release validation | Anonymized production snapshot |
| `prod` | Live | Real user data |

---

## Phase 7: Deployment & Launch

### 7.1 Launch Strategy

#### Pre-Launch (4 Weeks Before)
- [ ] Submit to App Store & Google Play (allow 1-2 weeks review)
- [ ] Set up production monitoring and alerting (Datadog + PagerDuty)
- [ ] Configure production push certificates (APNs + FCM)
- [ ] Load test production infrastructure (k6 or Gatling)
- [ ] Prepare press kit and landing page
- [ ] Recruit 50 beta testers in 3 target cities

#### Soft Launch (Week 1-2)
- **Markets:** Seattle, Portland, Austin (pet-friendly, tech-savvy, community-oriented)
- **Goal:** 500 downloads, 50 active alerts, 5 successful reunions
- **Tactics:** Local Reddit/Nextdoor posts, shelter partnerships, influencer dogs
- **KPIs:** D1 retention > 40%, alert creation conversion > 15%, crash-free rate > 99%

#### Public Launch (Week 3-4)
- **Markets:** Expand to top 20 US cities
- **Tactics:** Product Hunt launch, local news pitches, pet blogger outreach
- **Paid:** $5k Facebook/Instagram ads targeting pet owners in launch cities
- **KPIs:** 10k downloads, 500 active alerts, 50 reunions, 4.5+ star rating

### 7.2 App Store Optimization (ASO)

**App Name:** PawFinder — Find Lost Pets Locally
**Subtitle:** Reunite missing pets with your community
**Keywords:** lost pet, find my dog, missing cat, pet rescue, neighborhood, animal shelter
**Screenshots:**
1. Map view with "3 pets missing near you"
2. Create alert wizard (privacy highlighted)
3. Secure messaging interface
4. Success story / reunion moment
5. Leaderboard and badges

### 7.3 DevOps & Infrastructure

```yaml
# Production Deployment Pipeline
triggers:
  - tag: release-v*

stages:
  - build:
      - mvn clean package → Docker build → ECR
      - flutter build ios/android → EAS (or manual signing)
      - flutter build web → S3/CloudFront
  - test:
      - JUnit tests (blocking)
      - Integration tests with Testcontainers (blocking)
      - Flutter widget tests (blocking)
      - E2E smoke tests (blocking)
  - deploy:
      - api: ECS blue-green deployment
      - web: S3 invalidation
      - mobile: phased rollout (10% → 50% → 100%)
  - verify:
      - synthetic monitoring checks
      - error rate < 0.1%
      - rollback on anomaly detection
```

---

## Phase 8: Maintenance & Iteration

### 8.1 Monitoring & Alerting

| Metric | Threshold | Action |
|--------|-----------|--------|
| API Error Rate | > 0.5% | PagerDuty alert → investigate immediately |
| Push Notification Delay | > 10s | Escalate to infrastructure team |
| Alert Creation Failures | > 2% | Block release; hotfix required |
| Message Delivery Failures | > 1% | Check WebSocket cluster health |
| App Crash Rate | > 1% | Rollback latest mobile release |
| Payment Failures | > 5% | Check Stripe integration; notify users |
| JVM Heap Usage | > 80% | Scale ECS tasks or investigate memory leak |
| Flutter ANR Rate | > 0.5% | Profile and optimize render thread |

### 8.2 Feedback Loop

```
[User Feedback] → [Intercom/In-App Surveys] → [Product Board Triage]
    ↓
[Analytics Review] → [Amplitude/Mixpanel] → [Funnel Analysis]
    ↓
[Bi-Weekly Product Review] → [Prioritize Backlog] → [Sprint Planning]
    ↓
[Release] → [Monitor] → [Iterate]
```

### 8.3 Continuous Improvement Areas

| Area | Metric | Target | Review Frequency |
|------|--------|--------|------------------|
| Time-to-Alert | Minutes from missing to alert live | < 5 min | Weekly |
| Time-to-First-Sighting | Hours from alert to first report | < 4 hours | Weekly |
| Resolution Rate | % of alerts resolved within 7 days | > 60% | Monthly |
| User Retention | D30 retention for helpers | > 20% | Monthly |
| Trust Score | % of users feeling safe | > 90% | Quarterly |
| Revenue | MRR from rewards + subscriptions | Growth 10% MoM | Monthly |

### 8.4 Disaster Recovery

- **Database:** Daily automated backups to S3 (cross-region replication); point-in-time recovery enabled
- **Image Storage:** S3 versioning + cross-region replication; 99.999999999% durability
- **Service Outage:** ECS auto-scaling; multi-AZ deployment; failover to standby region (RPO < 1 hour, RTO < 4 hours)
- **Data Breach Response Plan:**
  1. Isolate affected systems within 15 minutes
  2. Notify security team and legal within 1 hour
  3. Assess scope and contain within 4 hours
  4. User notification within 72 hours (GDPR compliant)
  5. Post-incident review and hardening

---

## Appendices

### Appendix A: Glossary

| Term | Definition |
|------|------------|
| **Ping** | A push notification alerting users to a new missing pet in their area |
| **Alert** | A formal missing pet report created by an owner |
| **Sighting** | A community member's report of spotting a missing pet |
| **Fuzzing** | Intentional slight offset of GPS coordinates to protect exact location |
| **Rescuer Badge** | Reputation indicator for users with multiple successful reunions |
| **Shelter Portal** | Partner interface for shelters to upload found animals and match against alerts |

### Appendix B: Compliance Checklist

- [ ] GDPR: Right to erasure, data portability, consent management
- [ ] CCPA: Privacy policy disclosure, opt-out mechanisms
- [ ] COPPA: No accounts for users under 13; parental consent flow if needed
- [ ] Apple App Store: Human Guidelines (no harmful content, accurate metadata)
- [ ] Google Play: Family Policies, Location Permissions justification
- [ ] PCI-DSS: Stripe handles card data; no sensitive payment info stored locally

### Appendix C: Third-Party Dependencies

| Service | Purpose | Cost (Est.) | Fallback Plan |
|---------|---------|-------------|---------------|
| AWS ECS | Container hosting | $500/mo | Migrate to GCP Cloud Run |
| PostgreSQL (RDS) | Primary database | $300/mo | Self-managed EC2 |
| Mapbox | Maps & geocoding | $200/mo | Google Maps Platform |
| Stripe | Payments | 2.9% + $0.30/tx | PayPal Commerce |
| Twilio | SMS verification | $0.0075/SMS | MessageBird |
| Firebase FCM | Push notifications | Free tier | OneSignal |
| SendGrid | Transactional email | $90/mo | AWS SES |
| Sentry | Error tracking | $26/mo | Rollbar |

### Appendix D: Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Privacy breach exposing owner data | Low | Critical | Encryption, access controls, regular audits |
| Fake alerts / spam abuse | Medium | High | Rate limiting, verification, AI moderation |
| Scam: finder demands reward before proof | Medium | High | Escrow payments, sighting verification, education |
| Low user adoption in target city | Medium | High | Shelter partnerships, local marketing, referral incentives |
| Shelter API integration delays | Medium | Medium | Manual CSV upload fallback; phased partner rollout |
| Apple/Google reject app for location use | Low | High | Clear permission rationale; background location only when alert active |
| Competitor launch (e.g., Nextdoor feature) | Medium | Medium | Focus on anonymity and reward differentiation; speed to market |
| Flutter Web performance issues | Medium | Medium | Fallback to React for web; optimize Flutter Web builds |

### Appendix E: Success Metrics (North Star)

**North Star Metric:** Pets Reunited Per Month

**Supporting Metrics:**
1. **Activation:** % of new users who create or interact with an alert within 7 days
2. **Engagement:** Average sessions per helper per week
3. **Retention:** D30 retention for both owners and helpers
4. **Referral:** % of new users from organic shares/invites
5. **Revenue:** GMV (Gross Merchandise Value) of rewards processed + subscription revenue
6. **Trust:** NPS score from users; % of users who feel safe using the app

---

*Document Version: 2.0*  
*Last Updated: June 2026*  
*Tech Stack: Java 21 + Spring Boot + Flutter 3.22*  
*Next Review: Upon completion of MVP Sprint 6*
