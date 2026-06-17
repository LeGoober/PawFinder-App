import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for authentication operations.
///
/// Supports two auth flows:
/// 1. **Email + Password** — `registerWithEmail()` → `loginWithEmail()`
/// 2. **OAuth Provider** (Google) — `login()` with `authProvider` + `authId`
abstract class AuthRepository {
  /// Registers a new user with email and password.
  /// Backend auto-logs in and returns JWT tokens.
  Future<Either<Failure, User>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Logs in with email and password.
  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Registers a new user with phone number.
  /// Sends SMS verification code to the phone.
  Future<Either<Failure, User>> registerPhone(String phoneNumber);

  /// Verifies the SMS code and completes phone auth.
  Future<Either<Failure, User>> verifyPhone(
      String phoneNumber, String code);

  /// OAuth-style login via [authProvider] and [authId].
  /// Creates a new user if one doesn't exist.
  Future<Either<Failure, User>> login({
    required String authProvider,
    required String authId,
  });

  /// Refreshes the authentication token.
  Future<Either<Failure, String>> refreshToken();

  /// Returns the currently authenticated user.
  Future<Either<Failure, User>> getCurrentUser();
}
