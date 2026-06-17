import 'dart:io' show Platform;

class ApiConstants {
  ApiConstants._();

  /// Returns the correct base URL depending on platform and environment.
  ///
  /// - Web in production: uses `API_BASE_URL` env var (set in Docker/Render)
  /// - Android emulator: uses `10.0.2.2` to reach host localhost
  /// - All other platforms (web dev, iOS, desktop): uses localhost directly
  static String get baseUrl {
    // Production override via compile-time environment variable
    // Set with: --dart-define=API_BASE_URL=https://pawfinder-api-gateway.onrender.com
    const prodUrl = String.fromEnvironment('API_BASE_URL');
    if (prodUrl.isNotEmpty) return prodUrl;

    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:8080';
    } catch (_) {
      // Platform not available (e.g. web) — fall through
    }
    return 'http://localhost:8080';
  }

  static String get wsUrl {
    // Production WebSocket URL (derived from API base)
    const prodUrl = String.fromEnvironment('API_BASE_URL');
    if (prodUrl.isNotEmpty) {
      return prodUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://');
    }

    try {
      if (Platform.isAndroid) return 'ws://10.0.2.2:8080/ws';
    } catch (_) {}
    return 'ws://localhost:8080/ws';
  }

  // Auth endpoints
  static const String register = '/api/v1/auth/register';
  static const String verify = '/api/v1/auth/verify';
  static const String login = '/api/v1/auth/login';
  static const String emailRegister = '/api/v1/auth/email/register';
  static const String emailLogin = '/api/v1/auth/email/login';
  static const String refresh = '/api/v1/auth/refresh';
  static const String me = '/api/v1/auth/me';

  // Alert endpoints
  static const String alerts = '/api/v1/alerts';
  static String alertById(String id) => '/api/v1/alerts/$id';
  static const String alertsNearby = '/api/v1/alerts/nearby';

  // Pet endpoints
  static const String pets = '/api/v1/pets';
  static String petById(String id) => '/api/v1/pets/$id';

  // Sighting endpoints
  static const String sightings = '/api/v1/sightings';

  // Conversation endpoints
  static const String conversations = '/api/v1/conversations';
  static String conversationMessages(String id) =>
      '/api/v1/conversations/$id/messages';

  // Dashboard endpoints
  static const String dashboardMetrics = '/api/v1/dashboard/metrics';
  static const String leaderboard = '/api/v1/leaderboard';

  // Reward endpoints
  static const String rewards = '/api/v1/rewards';

  // Media endpoints
  static const String mediaUpload = '/api/v1/media/upload';
}
