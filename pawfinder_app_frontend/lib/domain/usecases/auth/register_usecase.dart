import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

/// Params for the [RegisterUseCase].
class RegisterParams extends Equatable {
  final String? phoneNumber;
  final String? email;
  final String? password;
  final String? displayName;

  /// Phone-based registration.
  const RegisterParams.phone({required this.phoneNumber})
      : email = null,
        password = null,
        displayName = null;

  /// Email-based registration.
  const RegisterParams.email({
    required this.email,
    required this.password,
    this.displayName,
  }) : phoneNumber = null;

  @override
  List<Object?> get props => [phoneNumber, email, password, displayName];
}

/// Registers a new user via phone number or email/password.
class RegisterUseCase extends UseCase<User, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    if (params.phoneNumber != null) {
      return _repository.registerPhone(params.phoneNumber!);
    }
    return _repository.registerWithEmail(
      email: params.email!,
      password: params.password!,
      displayName: params.displayName,
    );
  }
}
