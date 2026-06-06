# 🐾 PawFinder Backend

**Community-Driven Lost Pet Recovery Platform**

A 10-module microservices backend built with **Spring Boot 3.2.5** and **Java 21**, designed to power a mobile-first platform that helps communities reunite lost pets with their owners through real-time alerts, geospatial search, image matching, and reward incentives.

---

## 🏗 Architecture

```
pawfinder-app-backend/
├── pawfinder-api-gateway/       # Spring Cloud Gateway – routing, rate limiting, auth filtering
├── pawfinder-auth-service/      # Authentication, user management, JWT token issuance
├── pawfinder-alert-service/     # Lost/found pet alerts with PostGIS geospatial queries
├── pawfinder-messaging-service/ # Real-time chat between pet owners and finders (WebSocket)
├── pawfinder-matching-service/  # AWS Rekognition visual matching of found pets to lost alerts
├── pawfinder-reward-service/    # Stripe-based reward pledging and payout
├── pawfinder-media-service/     # AWS S3 image/video upload and serving
├── pawfinder-analytics-service/ # Dashboards, heatmaps, leaderboards, badges
├── pawfinder-notification-service/ # Push (FCM), SMS (Twilio), Email (SendGrid), RabbitMQ listener
└── pawfinder-shared/            # Shared DTOs, utilities, security filter, exceptions
```

---

## ✅ Prerequisites

| Tool         | Minimum Version |
|--------------|-----------------|
| Java         | 21 (LTS)        |
| Maven        | 3.9+            |
| Docker       | 24+             |
| Docker Compose | v2           |

---

## 🚀 Quick Start

### 1. Start Infrastructure

```bash
docker-compose up -d
```

This launches **PostgreSQL + PostGIS**, **Redis**, **RabbitMQ**, and **Elasticsearch** on your local machine.

### 2. Configure Environment

```bash
cp .env.example .env
```

Edit `.env` and set your API keys for any services you intend to test (Stripe, Twilio, AWS, SendGrid, Firebase). The defaults in `.env.example` are sufficient for local development of most modules.

### 3. Build All Modules

```bash
mvn clean install -DskipTests
```

This compiles all 10 modules in dependency order, including the shared library.

### 4. Start Services Individually

Each service runs on its own port and can be started independently:

```bash
# API Gateway (port 8080) – start this last, after all downstream services
mvn -pl pawfinder-api-gateway spring-boot:run

# Auth Service (port 8081)
mvn -pl pawfinder-auth-service spring-boot:run

# Alert Service (port 8082)
mvn -pl pawfinder-alert-service spring-boot:run

# Messaging Service (port 8083)
mvn -pl pawfinder-messaging-service spring-boot:run

# Reward Service (port 8084)
mvn -pl pawfinder-reward-service spring-boot:run

# Media Service (port 8085)
mvn -pl pawfinder-media-service spring-boot:run

# Analytics Service (port 8086)
mvn -pl pawfinder-analytics-service spring-boot:run

# Matching Service (port 8087)
mvn -pl pawfinder-matching-service spring-boot:run

# Notification Service (port 8088)
mvn -pl pawfinder-notification-service spring-boot:run
```

Alternatively, start all services at once with a port-mapped command:

```bash
mvn -pl pawfinder-auth-service,pawfinder-alert-service,pawfinder-messaging-service,pawfinder-reward-service,pawfinder-media-service,pawfinder-analytics-service,pawfinder-matching-service,pawfinder-notification-service spring-boot:run
```

---

## 📡 Service Ports

| Service          | Port  | Description                              |
|------------------|-------|------------------------------------------|
| API Gateway      | 8080  | Single entry point, routes to all services |
| Auth Service     | 8081  | Login, register, JWT lifecycle           |
| Alert Service    | 8082  | CRUD alerts, PostGIS proximity search    |
| Messaging Service| 8083  | Real-time chat via WebSocket             |
| Reward Service   | 8084  | Stripe payments for reward claims        |
| Media Service    | 8085  | AWS S3 upload and presigned URLs         |
| Analytics Service| 8086  | Dashboards, heatmaps, leaderboards       |
| Matching Service | 8087  | AWS Rekognition pet image matching       |
| Notification Svc | 8088  | Push, SMS, email dispatch via RabbitMQ   |

---

## 📖 API Documentation

Once a service is running, interactive Swagger UI is available at:

```
http://localhost:{port}/swagger-ui.html
```

| Service          | Swagger URL                              |
|------------------|------------------------------------------|
| API Gateway      | http://localhost:8080/swagger-ui.html    |
| Auth Service     | http://localhost:8081/swagger-ui.html    |
| Alert Service    | http://localhost:8082/swagger-ui.html    |
| Messaging Service| http://localhost:8083/swagger-ui.html    |
| Reward Service   | http://localhost:8084/swagger-ui.html    |
| Media Service    | http://localhost:8085/swagger-ui.html    |
| Analytics Service| http://localhost:8086/swagger-ui.html    |
| Matching Service | http://localhost:8087/swagger-ui.html    |
| Notification Svc | http://localhost:8088/swagger-ui.html    |

---

## 🧰 Technology Stack

| Category           | Technology                          |
|--------------------|-------------------------------------|
| Language           | Java 21                             |
| Framework          | Spring Boot 3.2.5                   |
| Gateway            | Spring Cloud Gateway 2023.0.1       |
| Database           | PostgreSQL 15 + PostGIS             |
| Caching            | Redis 7.2                           |
| Message Broker     | RabbitMQ 3.12                       |
| Search Engine      | Elasticsearch 8.12                  |
| Auth               | Spring Security + JWT (jjwt 0.12.5)|
| Payments           | Stripe SDK 24.0.0                   |
| SMS                | Twilio SDK 9.14.0                   |
| Email              | SendGrid 4.10.1                     |
| Push Notifications | Firebase Cloud Messaging            |
| Image Matching     | AWS Rekognition                     |
| File Storage       | AWS S3                              |
| Rate Limiting      | Bucket4j 8.7.0                      |
| Real-time Chat     | WebSocket + STOMP                   |
| API Docs           | SpringDoc OpenAPI 2.5.0             |
| Testing            | JUnit 5, Testcontainers, MockMvc    |
| Build              | Maven 3.9                           |
| Containerization   | Docker, Docker Compose              |

---

## 🛠 Development Guide

### Adding a New Service

1. Create a new Maven module directory (e.g., `pawfinder-new-service/`).
2. Add a `pom.xml` with `pawfinder-parent` as parent and `pawfinder-shared` as dependency.
3. Register the module in the root `pom.xml` `<modules>` section.
4. Create `NewServiceApplication.java` in `src/main/java/com/pawfinder/newservice/`.
5. Add `src/main/resources/application.yml` with a unique port.
6. Run `mvn clean install` from the root to compile the new module.

### Database Migrations

Each service manages its own Flyway migrations in `src/main/resources/db/migration/`. Name them with incremental version numbers:

```
V1__create_users_table.sql
V2__add_email_verified_column.sql
...
```

**Important:** Analytics service also has `flyway.enabled: true` via shared migration files.

### Running Tests

```bash
# Run tests for all modules
mvn test

# Run tests for a specific module
mvn -pl pawfinder-auth-service test

# Run a single test class
mvn -pl pawfinder-auth-service test -Dtest=AuthControllerTest
```

### Environment Variables

All services read configuration from environment variables (with sensible defaults for local dev). See `.env.example` for the full list. Spring Boot automatically maps `SPRING_APPLICATION_JSON`, `SERVER_PORT`, and other standard env vars.

### Code Style

- Use **Lombok** for boilerplate reduction (`@Data`, `@Builder`, `@RequiredArgsConstructor`).
- DTOs are defined in `pawfinder-shared` under `com.pawfinder.shared.dto`.
- Controllers delegate to service interfaces; implementations are `@Service`.
- Exception handling uses `@RestControllerAdvice` in `pawfinder-shared`.

---

## 📄 License

Internal project – not yet licensed for redistribution.
