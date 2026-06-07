import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository for authentication operations.
abstract class AuthRepository {
  /// Logs in with [email] and [password].
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Registers a new user.
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String displayName,
  });

  /// Verifies a user's email with a [code].
  Future<Either<Failure, bool>> verify({
    required String email,
    required String code,
  });

  /// Refreshes the authentication token.
  Future<Either<Failure, String>> refreshToken();

  /// Returns the currently authenticated user.
  Future<Either<Failure, User>> getCurrentUser();
}
