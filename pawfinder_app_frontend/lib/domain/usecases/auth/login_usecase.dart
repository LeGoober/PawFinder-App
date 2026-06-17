import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Params for the [LoginUseCase].
class LoginParams extends Equatable {
  final String authProvider;
  final String authId;

  const LoginParams({required this.authProvider, required this.authId});

  @override
  List<Object?> get props => [authProvider, authId];
}

/// Authenticates a user via an OAuth provider.
class LoginUseCase extends UseCase<User, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return _repository.login(
      authProvider: params.authProvider,
      authId: params.authId,
    );
  }
}
