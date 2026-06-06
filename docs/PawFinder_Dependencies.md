# PawFinder — Complete Dependencies List

> **Project:** PawFinder  
> **Stack:** Flutter (Mobile/Web) + Java Spring Boot (Backend)  
> **Date:** June 2026  
> **Version:** 1.0

---

## Table of Contents
1. [Flutter Dependencies](#1-flutter-dependencies)
2. [Java Spring Boot Dependencies](#2-java-spring-boot-dependencies)
3. [DevOps & Tooling](#3-devops--tooling)
4. [Third-Party Services](#4-third-party-services)
5. [Development Environment](#5-development-environment)

---

## 1. Flutter Dependencies

### pubspec.yaml — Production Dependencies

```yaml
name: pawfinder
version: 1.0.0+1
publish_to: none

environment:
  sdk: '>=3.3.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # ═══════════════════════════════════════════
  # STATE MANAGEMENT
  # ═══════════════════════════════════════════
  flutter_bloc: ^8.1.5              # BLoC pattern for business logic
  equatable: ^2.0.5                 # Value equality for states/events
  get_it: ^7.6.7                    # Dependency injection container
  injectable: ^2.3.2                # Code generation for DI

  # ═══════════════════════════════════════════
  # NETWORKING & API
  # ═══════════════════════════════════════════
  dio: ^5.4.0                       # HTTP client with interceptors
  retrofit: ^4.1.0                  # Type-safe REST API client
  json_annotation: ^4.8.1           # JSON serialization annotations
  web_socket_channel: ^2.4.4        # WebSocket client (STOMP fallback)
  stomp_dart_client: ^2.0.0         # STOMP protocol for real-time messaging
  connectivity_plus: ^5.0.2         # Network state monitoring
  cached_network_image: ^3.3.0      # Image caching with placeholders

  # ═══════════════════════════════════════════
  # LOCAL STORAGE & CACHE
  # ═══════════════════════════════════════════
  hive: ^2.2.3                      # Fast local NoSQL database
  hive_flutter: ^1.1.0              # Hive Flutter integration
  shared_preferences: ^2.2.2        # Simple key-value storage
  flutter_secure_storage: ^9.0.0    # Encrypted storage (tokens, secrets)

  # ═══════════════════════════════════════════
  # MAPS & LOCATION
  # ═══════════════════════════════════════════
  google_maps_flutter: ^2.5.0       # Native Google Maps
  flutter_map: ^6.1.0                 # Open-source map alternative (Mapbox)
  latlong2: ^0.9.0                    # LatLng calculations for flutter_map
  geolocator: ^10.1.0                 # GPS location services
  geocoding: ^2.1.1                   # Address ↔ Coordinates conversion
  flutter_polyline_points: ^2.0.0     # Route drawing on maps

  # ═══════════════════════════════════════════
  # NOTIFICATIONS
  # ═══════════════════════════════════════════
  firebase_messaging: ^14.7.0       # Push notifications (FCM)
  flutter_local_notifications: ^16.3.0  # Local notifications
  awesome_notifications: ^0.9.3       # Rich local notifications (images, actions)

  # ═══════════════════════════════════════════
  # AUTHENTICATION
  # ═══════════════════════════════════════════
  firebase_auth: ^4.16.0            # Firebase Authentication
  google_sign_in: ^6.2.0              # Google OAuth login
  sign_in_with_apple: ^5.0.0          # Apple Sign-In
  local_auth: ^2.2.0                  # Biometric authentication (Face ID/Touch ID)

  # ═══════════════════════════════════════════
  # UI COMPONENTS & DESIGN
  # ═══════════════════════════════════════════
  flutter_screenutil: ^5.9.0          # Responsive screen sizing
  shimmer: ^3.0.0                     # Skeleton loading animations
  photo_view: ^0.14.0                 # Zoomable image viewer
  flutter_staggered_grid_view: ^0.7.0 # Grid layouts for galleries
  flutter_slidable: ^3.0.1            # Swipe actions on list items
  pull_to_refresh: ^2.0.0             # Pull-to-refresh indicator
  modal_bottom_sheet: ^3.0.0          # Advanced bottom sheets
  flutter_animate: ^4.5.0              # Animation utilities
  confetti: ^0.7.0                    # Celebration particles (reunion success)
  lottie: ^3.0.0                      # After Effects animations (empty states)

  # ═══════════════════════════════════════════
  # MEDIA & CAMERA
  # ═══════════════════════════════════════════
  image_picker: ^1.0.7                # Camera/gallery photo picker
  image_cropper: ^5.0.1               # Photo cropping before upload
  photo_manager: ^3.0.0                 # Photo gallery access
  flutter_image_compress: ^2.2.0      # Compress images before upload
  video_player: ^2.8.2                # Video playback (sighting evidence)
  chewie: ^1.7.1                        # Video player UI wrapper

  # ═══════════════════════════════════════════
  # UTILITIES
  # ═══════════════════════════════════════════
  intl: ^0.19.0                       # Internationalization, date formatting
  uuid: ^4.3.0                        # UUID generation
  permission_handler: ^11.1.0         # Runtime permission requests
  url_launcher: ^6.2.0                # Open URLs, phone, email
  share_plus: ^7.2.0                  # Native share sheet
  path_provider: ^2.1.1               # File system paths
  package_info_plus: ^5.0.1           # App version info
  device_info_plus: ^9.1.2            # Device information
  app_settings: ^5.1.1                # Open system settings
  logger: ^2.0.2                      # Structured logging
  dartz: ^0.10.1                      # Functional programming (Either, Option)

  # ═══════════════════════════════════════════
  # PAYMENTS
  # ═══════════════════════════════════════════
  flutter_stripe: ^9.6.0              # Stripe payment UI
  stripe_platform_interface: ^9.6.0   # Stripe platform bindings
  pay: ^1.1.2                          # Google/Apple Pay integration

  # ═══════════════════════════════════════════
  # ANALYTICS & MONITORING
  # ═══════════════════════════════════════════
  firebase_analytics: ^10.8.0         # User behavior analytics
  firebase_crashlytics: ^3.4.0        # Crash reporting
  sentry_flutter: ^7.16.0             # Error tracking & performance
  mixpanel_flutter: ^2.2.0            # Product analytics (funnels, retention)

  # ═══════════════════════════════════════════
  # FIREBASE CORE
  # ═══════════════════════════════════════════
  firebase_core: ^2.24.0              # Firebase SDK core
  cloud_firestore: ^4.14.0            # NoSQL backup (optional sync layer)
  firebase_storage: ^11.6.0          # Image backup storage (optional)

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0               # Dart/Flutter linting rules

  # Code Generation
  build_runner: ^2.4.8                # Dart build system
  retrofit_generator: ^8.1.0          # Generate API clients from annotations
  hive_generator: ^2.0.1              # Generate Hive adapters
  json_serializable: ^6.7.1          # Generate JSON serialization code
  injectable_generator: ^2.4.1         # Generate DI registration code
  freezed: ^2.4.7                      # Immutable data classes with unions
  freezed_annotation: ^2.4.1          # Freezed annotations

  # Testing
  mockito: ^5.4.4                     # Mocking for unit tests
  bloc_test: ^9.1.5                   # Testing BLoC states
  integration_test:                   # E2E testing
    sdk: flutter
  patrol: ^3.0.0                      # Native UI testing framework
```

### Flutter Dependency Categories Summary

| Category | Packages | Purpose |
|----------|----------|---------|
| **State Management** | `flutter_bloc`, `equatable`, `get_it`, `injectable` | BLoC pattern, DI, equality |
| **Networking** | `dio`, `retrofit`, `web_socket_channel`, `stomp_dart_client` | REST, WebSocket, STOMP |
| **Storage** | `hive`, `shared_preferences`, `flutter_secure_storage` | Local data, cache, secrets |
| **Maps** | `google_maps_flutter`, `flutter_map`, `geolocator`, `geocoding` | Location, maps, GPS |
| **Notifications** | `firebase_messaging`, `flutter_local_notifications` | Push, local alerts |
| **Auth** | `firebase_auth`, `google_sign_in`, `sign_in_with_apple`, `local_auth` | OAuth, biometrics |
| **UI** | `flutter_screenutil`, `shimmer`, `photo_view`, `flutter_slidable`, `modal_bottom_sheet`, `flutter_animate`, `confetti`, `lottie` | Responsive design, loading, animations |
| **Media** | `image_picker`, `image_cropper`, `flutter_image_compress` | Camera, gallery, compression |
| **Payments** | `flutter_stripe`, `pay` | Stripe, Apple/Google Pay |
| **Analytics** | `firebase_analytics`, `firebase_crashlytics`, `sentry_flutter`, `mixpanel_flutter` | Tracking, crashes, funnels |
| **Utilities** | `intl`, `uuid`, `permission_handler`, `share_plus`, `logger`, `dartz` | Helpers, permissions, sharing |
| **Testing** | `mockito`, `bloc_test`, `patrol`, `integration_test` | Unit, widget, E2E tests |
| **Code Gen** | `build_runner`, `retrofit_generator`, `hive_generator`, `json_serializable`, `freezed` | Auto-generate boilerplate |

---

## 2. Java Spring Boot Dependencies

### pom.xml — Parent POM (Multi-Module)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.5</version>
        <relativePath/>
    </parent>

    <groupId>com.pawfinder</groupId>
    <artifactId>pawfinder-parent</artifactId>
    <version>1.0.0-SNAPSHOT</version>
    <packaging>pom</packaging>

    <properties>
        <java.version>21</java.version>
        <spring-cloud.version>2023.0.1</spring-cloud.version>
        <testcontainers.version>1.19.7</testcontainers.version>
        <jjwt.version>0.12.5</jjwt.version>
        <stripe.version>24.0.0</stripe.version>
        <twilio.version>9.14.0</twilio.version>
        <sendgrid.version>4.10.1</sendgrid.version>
        <bucket4j.version>8.7.0</bucket4j.version>
        <aws.sdk.version>2.25.0</aws.sdk.version>
        <mapstruct.version>1.5.5.Final</mapstruct.version>
        <lombok.version>1.18.32</lombok.version>
    </properties>

    <modules>
        <module>pawfinder-api-gateway</module>
        <module>pawfinder-auth-service</module>
        <module>pawfinder-alert-service</module>
        <module>pawfinder-messaging-service</module>
        <module>pawfinder-matching-service</module>
        <module>pawfinder-reward-service</module>
        <module>pawfinder-notification-service</module>
        <module>pawfinder-media-service</module>
        <module>pawfinder-analytics-service</module>
        <module>pawfinder-shared</module>
    </modules>

    <dependencyManagement>
        <dependencies>
            <!-- Spring Cloud BOM -->
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>

            <!-- Testcontainers BOM -->
            <dependency>
                <groupId>org.testcontainers</groupId>
                <artifactId>testcontainers-bom</artifactId>
                <version>${testcontainers.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>

            <!-- Internal modules -->
            <dependency>
                <groupId>com.pawfinder</groupId>
                <artifactId>pawfinder-shared</artifactId>
                <version>${project.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.springframework.boot</groupId>
                    <artifactId>spring-boot-maven-plugin</artifactId>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
</project>
```

### Service-Level Dependencies (Each Microservice)

```xml
<!-- Common dependencies for ALL services -->
<dependencies>
    <!-- ═══════════════════════════════════════════ -->
    <!-- SPRING BOOT STARTERS -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-validation</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-aop</artifactId>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- SECURITY -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-security</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-api</artifactId>
        <version>${jjwt.version}</version>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-impl</artifactId>
        <version>${jjwt.version}</version>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt-jackson</artifactId>
        <version>${jjwt.version}</version>
        <scope>runtime</scope>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- DATABASE & ORM -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>org.hibernate.orm</groupId>
        <artifactId>hibernate-spatial</artifactId>
        <version>6.4.4.Final</version>
    </dependency>
    <dependency>
        <groupId>org.flywaydb</groupId>
        <artifactId>flyway-core</artifactId>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- CACHE & SESSION -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-redis</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.session</groupId>
        <artifactId>spring-session-data-redis</artifactId>
    </dependency>
    <dependency>
        <groupId>com.bucket4j</groupId>
        <artifactId>bucket4j-core</artifactId>
        <version>${bucket4j.version}</version>
    </dependency>
    <dependency>
        <groupId>com.bucket4j</groupId>
        <artifactId>bucket4j-redis</artifactId>
        <version>${bucket4j.version}</version>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- MESSAGE QUEUE -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-amqp</artifactId>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- SEARCH -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
    </dependency>
    <dependency>
        <groupId>co.elastic.clients</groupId>
        <artifactId>elasticsearch-java</artifactId>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- WEBSOCKET (Messaging Service) -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-websocket</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-messaging</artifactId>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- API DOCUMENTATION -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springdoc</groupId>
        <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
        <version>2.5.0</version>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- AWS SDK -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>s3</artifactId>
        <version>${aws.sdk.version}</version>
    </dependency>
    <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>rekognition</artifactId>
        <version>${aws.sdk.version}</version>
    </dependency>
    <dependency>
        <groupId>software.amazon.awssdk</groupId>
        <artifactId>ses</artifactId>
        <version>${aws.sdk.version}</version>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- THIRD-PARTY INTEGRATIONS -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>com.stripe</groupId>
        <artifactId>stripe-java</artifactId>
        <version>${stripe.version}</version>
    </dependency>
    <dependency>
        <groupId>com.twilio.sdk</groupId>
        <artifactId>twilio</artifactId>
        <version>${twilio.version}</version>
    </dependency>
    <dependency>
        <groupId>com.sendgrid</groupId>
        <artifactId>sendgrid-java</artifactId>
        <version>${sendgrid.version}</version>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- UTILITIES -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>${lombok.version}</version>
        <optional>true</optional>
    </dependency>
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>${mapstruct.version}</version>
    </dependency>
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct-processor</artifactId>
        <version>${mapstruct.version}</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>com.google.guava</groupId>
        <artifactId>guava</artifactId>
        <version>33.1.0-jre</version>
    </dependency>
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-lang3</artifactId>
        <version>3.14.0</version>
    </dependency>
    <dependency>
        <groupId>com.fasterxml.jackson.datatype</groupId>
        <artifactId>jackson-datatype-jsr310</artifactId>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- MONITORING & METRICS -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>io.micrometer</groupId>
        <artifactId>micrometer-registry-datadog</artifactId>
        <scope>runtime</scope>
    </dependency>
    <dependency>
        <groupId>io.micrometer</groupId>
        <artifactId>micrometer-tracing-bridge-otel</artifactId>
    </dependency>
    <dependency>
        <groupId>io.opentelemetry</groupId>
        <artifactId>opentelemetry-exporter-zipkin</artifactId>
    </dependency>

    <!-- ═══════════════════════════════════════════ -->
    <!-- TESTING -->
    <!-- ═══════════════════════════════════════════ -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-test</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.testcontainers</groupId>
        <artifactId>junit-jupiter</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.testcontainers</groupId>
        <artifactId>postgresql</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.testcontainers</groupId>
        <artifactId>rabbitmq</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.testcontainers</groupId>
        <artifactId>elasticsearch</artifactId>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### API Gateway Specific Dependencies

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-gateway</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-circuitbreaker-reactor-resilience4j</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-loadbalancer</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
    </dependency>
</dependencies>
```

### Java Dependency Categories Summary

| Category | Libraries | Purpose |
|----------|-----------|---------|
| **Web Framework** | Spring Boot 3.2, Spring Web, Spring Validation | REST APIs, input validation |
| **Security** | Spring Security, OAuth2 Resource Server, JJWT 0.12 | Authentication, JWT tokens |
| **Database** | Spring Data JPA, PostgreSQL, Hibernate Spatial, Flyway | ORM, geospatial queries, migrations |
| **Cache** | Spring Data Redis, Bucket4j | Session store, rate limiting |
| **Messaging** | Spring AMQP, RabbitMQ | Async event processing |
| **Search** | Spring Data Elasticsearch, ES Java Client | Full-text search, geo queries |
| **Real-Time** | Spring WebSocket, Spring Messaging | STOMP chat, live updates |
| **Cloud** | AWS SDK v2 (S3, Rekognition, SES) | File storage, AI image analysis, email |
| **Payments** | Stripe Java SDK 24.x | Reward processing, marketplace payments |
| **Communication** | Twilio SDK, SendGrid Java | SMS verification, transactional email |
| **Docs** | SpringDoc OpenAPI 2.5 | Auto-generated API documentation |
| **Utilities** | Lombok, MapStruct, Guava, Commons Lang3 | Boilerplate reduction, DTO mapping |
| **Monitoring** | Micrometer, Datadog Registry, OpenTelemetry | Metrics, distributed tracing |
| **Testing** | Spring Boot Test, Testcontainers, H2 | Unit tests, integration tests, in-memory DB |

---

## 3. DevOps & Tooling

### Infrastructure & Deployment

| Tool | Version | Purpose |
|------|---------|---------|
| **Docker** | 24.x | Containerization for all services |
| **Docker Compose** | 2.24.x | Local development environment |
| **AWS CLI** | 2.x | Cloud resource management |
| **Terraform** | 1.7.x | Infrastructure as Code (IaC) |
| **Kubernetes (EKS)** | 1.29.x | Container orchestration (production) |
| **kubectl** | 1.29.x | K8s cluster management |
| **Helm** | 3.14.x | K8s package management |

### CI/CD

| Tool | Version | Purpose |
|------|---------|---------|
| **GitHub Actions** | Latest | CI/CD pipelines |
| **Maven** | 3.9.x | Java build & dependency management |
| **Gradle** | 8.5.x | Alternative build tool (optional) |
| **Flutter CLI** | 3.22.x | Flutter builds, tests, deployment |
| **Fastlane** | 2.219.x | Mobile app store automation |
| **SonarQube** | 10.4.x | Code quality & security analysis |
| **OWASP ZAP** | 2.14.x | Security penetration testing |

### Monitoring & Observability

| Tool | Version | Purpose |
|------|---------|---------|
| **Datadog Agent** | Latest | APM, infrastructure monitoring |
| **Sentry** | SaaS | Error tracking (Flutter + Java) |
| **Grafana** | 10.3.x | Metrics dashboards |
| **Prometheus** | 2.49.x | Metrics collection |
| **Loki** | 2.9.x | Log aggregation |
| **Jaeger** | 1.52.x | Distributed tracing |
| **PagerDuty** | SaaS | Incident alerting |
| **Kibana** | 8.12.x | Log visualization (alternative) |

---

## 4. Third-Party Services

### Cloud Infrastructure (AWS)

| Service | Purpose | Estimated Cost |
|---------|---------|----------------|
| **Amazon ECS (Fargate)** | Container hosting for microservices | $400-600/mo |
| **Amazon RDS (PostgreSQL)** | Managed database with Multi-AZ | $300-500/mo |
| **Amazon ElastiCache (Redis)** | Managed Redis cluster | $100-200/mo |
| **Amazon S3** | Image/video storage | $50-100/mo |
| **Amazon CloudFront** | CDN for images and static assets | $50-100/mo |
| **Amazon MQ (RabbitMQ)** | Managed message broker | $100-150/mo |
| **Amazon OpenSearch** | Managed Elasticsearch | $200-300/mo |
| **AWS Rekognition** | AI image analysis (pet detection, scam check) | $50-100/mo |
| **AWS SES** | Transactional email (fallback) | $20-50/mo |
| **AWS Route 53** | DNS management | $5-10/mo |
| **AWS Certificate Manager** | SSL/TLS certificates | Free |
| **AWS WAF** | Web application firewall | $20-50/mo |
| **AWS CloudWatch** | Logs and basic monitoring | $30-50/mo |
| **AWS ECR** | Container image registry | $10-20/mo |
| **AWS EKS** (optional) | Kubernetes cluster (if not using ECS) | $150-250/mo |

### External APIs & SaaS

| Service | Purpose | Integration Library | Cost |
|---------|---------|---------------------|------|
| **Stripe** | Payment processing, reward escrow | `stripe-java` / `flutter_stripe` | 2.9% + $0.30/transaction |
| **Twilio** | SMS verification codes | `twilio` Java SDK | $0.0075/SMS |
| **SendGrid** | Transactional emails | `sendgrid-java` | $90/mo (100k emails) |
| **Firebase** | Auth, Push Notifications, Analytics, Crashlytics | `firebase_*` Flutter plugins | Free tier + pay-as-you-go |
| **Google Maps Platform** | Maps, geocoding, places API | `google_maps_flutter` | $200/mo credit + usage |
| **Mapbox** | Alternative maps (custom styling) | `flutter_map` | $200-500/mo |
| **Mixpanel** | Product analytics, funnels | `mixpanel_flutter` | $0-999/mo (tiered) |
| **Sentry** | Error tracking & performance monitoring | `sentry_flutter` / `sentry-spring-boot` | $26/mo (Team plan) |
| **Datadog** | APM, infrastructure monitoring, log management | Micrometer registry | $70/host/mo |
| **Cloudflare** | DNS, DDoS protection, CDN (optional) | — | Free-$20/mo |
| **1Password** | Secrets management (team vault) | — | $20/user/mo |
| **GitHub** | Source control, Actions CI/CD, Packages | — | $4/user/mo (Team) |

---

## 5. Development Environment

### Required Local Tools

| Tool | Minimum Version | Installation |
|------|-----------------|--------------|
| **Java JDK** | 21 LTS | `sdk install java 21.0.2-tem` or Adoptium |
| **Maven** | 3.9.6 | `sdk install maven 3.9.6` |
| **Flutter SDK** | 3.22.0 | `git clone` + `flutter doctor` |
| **Dart SDK** | 3.3.0 | Bundled with Flutter |
| **Android Studio** | Hedgehog (2023.1.1) | Download + Flutter plugin |
| **Xcode** | 15.0 | Mac App Store (macOS only) |
| **CocoaPods** | 1.14.0 | `sudo gem install cocoapods` (macOS only) |
| **Docker Desktop** | 4.27.0 | Download + WSL2 (Windows) |
| **PostgreSQL** | 15.5 | Docker or local install |
| **Redis** | 7.2.0 | Docker or local install |
| **RabbitMQ** | 3.12.0 | Docker |
| **Elasticsearch** | 8.12.0 | Docker |
| **Node.js** | 20.11.0 | For any web tooling, commit hooks |
| **Git** | 2.43.0 | System package manager |
| **Postman** | 10.22.0 | API testing & documentation |
| **pgAdmin** | 4.30.0 | PostgreSQL GUI (optional) |
| **RedisInsight** | 2.40.0 | Redis GUI (optional) |

### VS Code Extensions (Recommended)

| Extension | Publisher | Purpose |
|-----------|-----------|---------|
| **Dart** | Dart Code | Dart language support |
| **Flutter** | Dart Code | Flutter tooling, hot reload |
| **Extension Pack for Java** | Microsoft | Java development |
| **Spring Boot Extension Pack** | VMware | Spring Boot support |
| **Lombok** | Gabriel Basilio | Lombok annotation support |
| **YAML** | Red Hat | YAML editing |
| **GitLens** | GitKraken | Enhanced Git integration |
| **Docker** | Microsoft | Docker file editing, container management |
| **Thunder Client** | Rangav V | API testing (Postman alternative) |
| **Error Lens** | Alexander | Inline error highlighting |
| **GitHub Copilot** | GitHub | AI code completion (optional) |
| **Flutter Stylizer** | Max Contender | Dart code formatting |
| **Pubspec Assist** | Jeroen Meijer | Dependency management |

### IntelliJ IDEA / Android Studio Plugins

| Plugin | Purpose |
|--------|---------|
| **Flutter** | Flutter project support |
| **Dart** | Dart language support |
| **Spring Boot** | Spring framework support |
| **Lombok** | Lombok annotation processing |
| **Rainbow Brackets** | Bracket pair colorization |
| **.env files support** | Environment file editing |
| **Key Promoter X** | Learn keyboard shortcuts |
| **String Manipulation** | Text transformation utilities |

---

## Quick Reference: One-Command Install (macOS)

```bash
# Install SDKMAN for Java/Maven management
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# Install Java 21 and Maven
sdk install java 21.0.2-tem
sdk install maven 3.9.6

# Install Flutter (stable channel)
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$HOME/flutter/bin"
flutter doctor

# Install Docker (via Homebrew)
brew install --cask docker

# Install other tools
brew install git node postman
brew install --cask android-studio
brew install --cask visual-studio-code

# Verify everything
java -version
mvn -version
flutter --version
docker --version
```

---

*Document Version: 1.0*  
*Last Updated: June 2026*  
*Maintained by: Engineering Team*
