import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;
  final StreamController<bool> _authStateController = StreamController<bool>.broadcast();

  AuthService() : _storage = const FlutterSecureStorage();

  /// Initialize the service (no-op for now, async setup can go here)
  Future<void> initialize() async {}

  /// Persist the JWT (or equivalent) token to secure device storage.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _authStateController.add(true);
  }

  /// Retrieve the stored token, or `null` if none exists.
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// Remove the stored token (logout / session expiry).
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    _authStateController.add(false);
  }

  /// Convenience check – `true` when a token is currently stored.
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// A broadcast stream that emits `true` when a user signs in (or a
  /// token is saved) and `false` when they sign out.
  Stream<bool> get authStateStream => _authStateController.stream;

  /// Clean up the stream controller when the service is no longer
  /// needed (e.g. app disposal).
  void dispose() {
    _authStateController.close();
  }
}
