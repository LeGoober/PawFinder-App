# ── Stage 1: Build Flutter Web ──────────────────────────────
FROM ghcr.io/cirruslabs/flutter:3.41.6 AS build

WORKDIR /app

# API base URL — set via Docker build arg (Render sets API_BASE_URL env var in dashboard)
ARG API_BASE_URL=https://pawfinder-api-gateway.onrender.com
ARG CACHEBUST=2

COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

COPY . .
RUN echo "Building with API_BASE_URL=$API_BASE_URL" && flutter build web --release --no-tree-shake-icons --dart-define=API_BASE_URL=$API_BASE_URL

# ── Stage 2: Serve with Nginx ────────────────────────────────
FROM nginx:1.27-alpine

# Copy built assets
COPY --from=build /app/build/web /usr/share/nginx/html

# Custom Nginx config — SPA fallback + gzip + security headers
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=15s --timeout=3s --retries=3 \
  CMD wget -qO- http://localhost:80/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
