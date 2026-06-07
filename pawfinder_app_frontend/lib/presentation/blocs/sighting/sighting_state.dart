part of 'sighting_cubit.dart';

abstract class SightingState extends Equatable {
  const SightingState();

  @override
  List<Object?> get props => [];
}

class SightingInitial extends SightingState {
  const SightingInitial();
}

class SightingLoading extends SightingState {
  const SightingLoading();
}

class SightingsLoaded extends SightingState {
  final List<_MockSighting> sightings;

  const SightingsLoaded({required this.sightings});

  @override
  List<Object?> get props => [sightings];
}

class SightingReported extends SightingState {
  const SightingReported();
}

class SightingError extends SightingState {
  final String message;

  const SightingError({required this.message});

  @override
  List<Object?> get props => [message];
}
