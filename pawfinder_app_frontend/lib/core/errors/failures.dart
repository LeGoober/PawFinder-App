import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Failures are value-objects that carry a user-facing message and can be
/// compared by value thanks to [Equatable].
abstract class Failure extends Equatable {
  const Failure([this.message = 'An unexpected error occurred']);

  /// A human-readable description of the failure.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure caused by an error on the server side (4xx / 5xx responses).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error']);
}

/// Failure caused by the absence of a network connection.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// Failure caused by a local cache error.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);
}
