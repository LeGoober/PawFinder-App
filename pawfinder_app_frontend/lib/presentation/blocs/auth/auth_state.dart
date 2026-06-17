part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// No auth state — user is logged out.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Auth operation in progress (Google sign-in, checking token, etc.).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Verification code sent to phone — awaiting code entry.
class AuthCodeSent extends AuthState {
  final String phoneNumber;

  const AuthCodeSent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

/// User is fully authenticated.
class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// SMS verification failed.
class AuthVerificationFailed extends AuthState {
  final String message;

  const AuthVerificationFailed({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Auth error (network, server, cancelled, etc.).
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
