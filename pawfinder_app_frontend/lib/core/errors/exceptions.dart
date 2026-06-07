/// Thrown when the server returns an error response (4xx / 5xx).
class ServerException implements Exception {
  const ServerException([this.message = 'An unexpected server error occurred']);

  /// A human-readable description of the error.
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Thrown when a local cache operation fails.
class CacheException implements Exception {
  const CacheException([this.message = 'A cache error occurred']);

  /// A human-readable description of the error.
  final String message;

  @override
  String toString() => 'CacheException: $message';
}

/// Thrown when the device has no network connectivity.
class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection']);

  /// A human-readable description of the error.
  final String message;

  @override
  String toString() => 'NetworkException: $message';
}
