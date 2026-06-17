import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/constants/api_constants.dart';

/// Google Sign-In user data returned after a successful sign-in.
class GoogleSignInUser {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const GoogleSignInUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });
}

class AuthService {
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey = 'auth_user';

  final FlutterSecureStorage _storage;
  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();

  // Google Sign-In instance — configured for web + mobile
  late final GoogleSignIn _googleSignIn;

  AuthService() : _storage = const FlutterSecureStorage() {
    _googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
    );
  }

  /// Initialize the service.
  Future<void> initialize() async {}

  // ── Google Sign-In ──────────────────────────────────────────────

  /// Starts the Google Sign-In flow. Returns user data on success,
  /// or null if the user cancelled.
  Future<GoogleSignInUser?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) return null;

      // Re-authenticate to get fresh credentials with ID token
      final auth = await account.authentication;

      return GoogleSignInUser(
        id: account.id,
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
      );
    } catch (e) {
      // User cancelled or network error — rethrow for the cubit to handle
      rethrow;
    }
  }

  /// Signs out of Google and clears local auth state.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Best-effort — may fail if already signed out
    }
    await deleteToken();
  }

  // ── Token Management ────────────────────────────────────────────

  /// Persist the access + refresh tokens to secure device storage.
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _tokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
    _authStateController.add(true);
  }

  /// Retrieve the stored access token.
  Future<String?> getToken() async {
    return _storage.read(key: _tokenKey);
  }

  /// Retrieve the stored refresh token.
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Attempt to refresh the access token using the stored refresh token.
  /// The backend expects the refresh token as a Bearer token in the
  /// Authorization header.
  Future<String?> refreshToken() async {
    try {
      final refresh = await getRefreshToken();
      if (refresh == null || refresh.isEmpty) return null;

      final dio = Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ));

      final response = await dio.post(
        ApiConstants.refresh,
        options: Options(headers: {
          'Authorization': 'Bearer $refresh',
        }),
      );

      final data = response.data as Map<String, dynamic>;
      final newAccess = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String?;

      if (newAccess != null) {
        await saveTokens(accessToken: newAccess, refreshToken: newRefresh);
        return newAccess;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Remove all stored tokens (logout / session expiry).
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
    _authStateController.add(false);
  }

  /// Convenience check — `true` when a token is currently stored.
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── User Profile Cache ──────────────────────────────────────────

  /// Cache the current user profile as JSON.
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user));
  }

  /// Retrieve cached user profile.
  Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Clear cached user profile.
  Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }

  // ── Stream ──────────────────────────────────────────────────────

  /// A broadcast stream that emits `true` when a user signs in and
  /// `false` when they sign out.
  Stream<bool> get authStateStream => _authStateController.stream;

  /// Clean up.
  void dispose() {
    _authStateController.close();
  }
}
