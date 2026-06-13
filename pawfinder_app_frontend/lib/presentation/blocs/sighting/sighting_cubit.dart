import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawfinder_app/domain/entities/sighting.dart';
import 'package:pawfinder_app/domain/repositories/sighting_repository.dart';

part 'sighting_state.dart';

class SightingCubit extends Cubit<SightingState> {
  final SightingRepository _sightingRepository;

  SightingCubit({
    required SightingRepository sightingRepository,
  })  : _sightingRepository = sightingRepository,
        super(SightingInitial());

  /// Load sightings for a specific alert.
  Future<void> loadSightings(String alertId) async {
    emit(SightingLoading());

    try {
      final result = await _sightingRepository.getSightingsForAlert(alertId);

      result.fold(
        (failure) => emit(SightingError(message: failure.message)),
        (sightings) => emit(SightingsLoaded(sightings: sightings)),
      );
    } catch (e) {
      emit(SightingError(message: e.toString()));
    }
  }

  /// Report a new sighting.
  Future<void> reportSighting({
    required String alertId,
    required String finderId,
    required double lat,
    required double lng,
    List<String> photoUrls = const [],
    String? notes,
  }) async {
    emit(SightingLoading());

    try {
      final result = await _sightingRepository.reportSighting(
        alertId: alertId,
        finderId: finderId,
        lat: lat,
        lng: lng,
        photoUrls: photoUrls,
        notes: notes,
      );

      result.fold(
        (failure) => emit(SightingError(message: failure.message)),
        (sighting) => emit(SightingReported(sighting: sighting)),
      );
    } catch (e) {
      emit(SightingError(message: e.toString()));
    }
  }

  /// Confirm a sighting.
  Future<void> confirmSighting(String sightingId) async {
    emit(SightingLoading());

    try {
      final result = await _sightingRepository.confirmSighting(sightingId);

      result.fold(
        (failure) => emit(SightingError(message: failure.message)),
        (sighting) => emit(SightingReported(sighting: sighting)),
      );
    } catch (e) {
      emit(SightingError(message: e.toString()));
    }
  }
}
