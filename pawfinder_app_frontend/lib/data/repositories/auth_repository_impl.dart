import 'package:dartz/dartz.dart';

import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../services/auth_service.dart';

/// Real API implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _client;
  final AuthService _authService;

  AuthRepositoryImpl({
    required ApiClient client,
    required AuthService authService,
  })  : _client = client,
        _authService = authService;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final json = await _client.post(ApiConstants.login, data: {
        'email': email,
        'password': password,
      });
      final data = json as Map<String, dynamic>;

      // Persist tokens
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken != null) {
        await _authService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }

      // Parse user from nested structure or direct
      final userData = (data['user'] ?? data) as Map<String, dynamic>;
      final user = UserModel.fromJson(userData);
      await _authService.saveUser(userData);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final json = await _client.post(ApiConstants.register, data: {
        'email': email,
        'password': password,
        'displayName': displayName,
      });
      final data = json as Map<String, dynamic>;
      final accessToken = data['accessToken'] as String?;
      final refreshToken = data['refreshToken'] as String?;
      if (accessToken != null) {
        await _authService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }
      final userData = (data['user'] ?? data) as Map<String, dynamic>;
      final user = UserModel.fromJson(userData);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verify({
    required String email,
    required String code,
  }) async {
    try {
      await _client.post(ApiConstants.verify, data: {
        'email': email,
        'code': code,
      });
      return const Right(true);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

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
      final user = UserModel.fromJson(json as Map<String, dynamic>);
      await _authService.saveUser(json as Map<String, dynamic>);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      // Fall back to cached user
      final cached = await _authService.getUser();
      if (cached != null) {
        return Right(UserModel.fromJson(cached).toEntity());
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
