import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final User _mockUser = User(
    id: 'usr_a1b2c3',
    authProvider: 'email',
    displayName: 'Sipho Ndlovu',
    verified: true,
    rescuerBadgeLevel: 2,
    createdAt: DateTime(2025, 1, 15),
    lastActive: DateTime(2026, 6, 6, 12, 0),
  );

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'fail@test.com') {
      return Left(ServerFailure('Invalid email or password'));
    }
    return Right(_mockUser);
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'exists@test.com') {
      return Left(NetworkFailure('A user with this email already exists'));
    }
    return Right(_mockUser.copyWith(displayName: displayName));
  }

  @override
  Future<Either<Failure, bool>> verify({
    required String email,
    required String code,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (code == '000000') {
      return Left(NetworkFailure('Invalid verification code'));
    }
    return const Right(true);
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    await Future.delayed(const Duration(seconds: 1));
    return const Right('mock-refreshed-jwt-token-a7x9k2');
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(_mockUser);
  }
}
