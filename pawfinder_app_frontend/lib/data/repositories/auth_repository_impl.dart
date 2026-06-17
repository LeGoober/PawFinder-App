import 'package:dartz/dartz.dart';
import 'package:pawfinder_app/core/constants/api_constants.dart';
import 'package:pawfinder_app/core/errors/exceptions.dart';
import 'package:pawfinder_app/core/errors/failures.dart';
import 'package:pawfinder_app/data/datasources/remote/api_client.dart';
import 'package:pawfinder_app/data/models/user_model.dart';
import 'package:pawfinder_app/domain/entities/user.dart';
import 'package:pawfinder_app/domain/repositories/auth_repository.dart';
import 'package:pawfinder_app/services/auth_service.dart';

/// Real API implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _client;
  final AuthService _authService;

  AuthRepositoryImpl({
    required ApiClient client,
    required AuthService authService,
  })  : _client = client,
        _authService = authService;

  // ── Phone auth ─────────────────────────────────────────────────

  @override
  Future<Either<Failure, User>> registerPhone(String phoneNumber) async {
    try {
      final json = await _client.post(ApiConstants.register, data: {
        'phoneNumber': phoneNumber,
      });
      final data = json as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyPhone(
      String phoneNumber, String code) async {
    try {
      final json = await _client.post(ApiConstants.verify, data: {
        'phoneNumber': phoneNumber,
        'verificationCode': code,
      });
      final data = json as Map<String, dynamic>;
      return _handleTokenResponse(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Email + Password ──────────────────────────────────────────

  @override
  Future<Either<Failure, User>> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final json = await _client.post(ApiConstants.emailRegister, data: {
        'email': email,
        'password': password,
        if (displayName != null) 'displayName': displayName,
      });
      final data = json as Map<String, dynamic>;
      return _handleTokenResponse(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final json = await _client.post(ApiConstants.emailLogin, data: {
        'email': email,
        'password': password,
      });
      final data = json as Map<String, dynamic>;
      return _handleTokenResponse(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Provider auth (Google) ────────────────────────────────────

  @override
  Future<Either<Failure, User>> login({
    required String authProvider,
    required String authId,
  }) async {
    try {
      final json = await _client.post(ApiConstants.login, data: {
        'authProvider': authProvider,
        'authId': authId,
      });
      final data = json as Map<String, dynamic>;
      return _handleTokenResponse(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Token / Profile ───────────────────────────────────────────

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final newToken = await _authService.refreshToken();
      if (newToken != null) return Right(newToken);
      return Left(ServerFailure('Unable to refresh session'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final json = await _client.get(ApiConstants.me);
      final data = json as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      await _authService.saveUser(data);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      final cached = await _authService.getUser();
      if (cached != null) {
        return Right(UserModel.fromJson(cached).toEntity());
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  // ── Internal ──────────────────────────────────────────────────

  /// Parses a token response, persists tokens, and fetches the user profile.
  Future<Either<Failure, User>> _handleTokenResponse(
      Map<String, dynamic> data) async {
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    if (accessToken != null) {
      await _authService.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
    return getCurrentUser();
  }
}
