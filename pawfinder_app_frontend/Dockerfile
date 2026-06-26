# ── Stage 1: Build Flutter Web ──────────────────────────────
FROM ghcr.io/cirruslabs/flutter:3.41.6 AS build

# Accept build-time args for targeting prod/staging.
# CACHEBUST — increment to force a clean Docker rebuild on Render
# (Render caches layers aggressively; changing this arg invalidates the cache).
ARG CACHEBUST=3
ARG API_BASE_URL=https://pawfinder-api-gateway.onrender.com
ARG WS_URL=wss://pawfinder-api-gateway.onrender.com/ws

WORKDIR /app

COPY pubspec.yaml pubspec.lock* ./
RUN flutter pub get

COPY . .

# Build with explicit production URLs embedded at compile time.
# --no-tree-shake-icons preserves Material icons (Material 3 tray).
RUN echo "Cache bust: $CACHEBUST — API: $API_BASE_URL" \
    && flutter build web --release --no-tree-shake-icons \
    --dart-define=API_BASE_URL=${API_BASE_URL} \
    --dart-define=WS_URL=${WS_URL}

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
