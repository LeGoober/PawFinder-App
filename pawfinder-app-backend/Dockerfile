# ── Stage 1: Build with Maven ───────────────────────────────
# Build arg: SERVICE_NAME = e.g. pawfinder-api-gateway, pawfinder-auth-service, etc.
FROM maven:3.9-eclipse-temurin-21-alpine AS build

ARG SERVICE_NAME
WORKDIR /app

# Copy shared module first (Maven dependency cache)
COPY pawfinder-shared/pom.xml pawfinder-shared/
COPY pawfinder-shared/src pawfinder-shared/src/

# Copy parent POM and target service
COPY pom.xml .
COPY ${SERVICE_NAME}/pom.xml ${SERVICE_NAME}/
COPY ${SERVICE_NAME}/src ${SERVICE_NAME}/src/

# Build only the target service (skip tests for CI speed)
RUN mvn package -pl ${SERVICE_NAME} -am -DskipTests -q

# ── Stage 2: Runtime ────────────────────────────────────────
FROM eclipse-temurin:21-jre-alpine

ARG SERVICE_NAME
WORKDIR /app

# Copy the built JAR
COPY --from=build /app/${SERVICE_NAME}/target/*.jar app.jar

# Non-root user
RUN addgroup -S pawfinder && adduser -S pawfinder -G pawfinder
USER pawfinder

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:8080/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
