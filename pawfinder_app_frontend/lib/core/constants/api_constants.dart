class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://10.0.2.2:8080'; // Android emulator → host localhost
  static const String wsUrl = 'ws://10.0.2.2:8080/ws';

  // Auth endpoints
  static const String register = '/api/v1/auth/register';
  static const String verify = '/api/v1/auth/verify';
  static const String login = '/api/v1/auth/login';
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
