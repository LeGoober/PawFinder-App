part of 'alert_cubit.dart';

abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

class AlertInitial extends AlertState {
  const AlertInitial();
}

class AlertLoading extends AlertState {
  const AlertLoading();
}

class AlertsLoaded extends AlertState {
  final List<Alert> alerts;

  const AlertsLoaded({required this.alerts});

  @override
  List<Object?> get props => [alerts];
}

class AlertCreated extends AlertState {
  const AlertCreated();
}

class AlertResolved extends AlertState {
  const AlertResolved();
}

class AlertCancelled extends AlertState {
  const AlertCancelled();
}

class AlertError extends AlertState {
  final String message;

  const AlertError({required this.message});

  @override
  List<Object?> get props => [message];
}
