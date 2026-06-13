import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawfinder_app/domain/entities/alert.dart';
import 'package:pawfinder_app/domain/repositories/alert_repository.dart';
import 'package:pawfinder_app/services/location_service.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  final AlertRepository _alertRepository;
  final LocationService? _locationService;

  AlertCubit({
    required AlertRepository alertRepository,
    LocationService? locationService,
  })  : _alertRepository = alertRepository,
        _locationService = locationService,
        super(AlertInitial());

  /// Load nearby alerts based on current location.
  Future<void> loadAlerts({double? lat, double? lng, double radiusKm = 10.0}) async {
    emit(const AlertLoading());

    try {
      double useLat = lat ?? -26.2041; // Johannesburg default
      double useLng = lng ?? 28.0473;

      if (_locationService != null && lat == null) {
        try {
          final pos = await _locationService.getCurrentPosition();
          useLat = pos.latitude;
          useLng = pos.longitude;
        } catch (_) {
          // Use defaults
        }
      }

      final result = await _alertRepository.getNearbyAlerts(
        lat: useLat,
        lng: useLng,
        radiusKm: radiusKm,
      );

      result.fold(
        (failure) => emit(AlertError(message: failure.message)),
        (alerts) => emit(AlertsLoaded(alerts: alerts)),
      );
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  /// Create a new missing-pet alert.
  Future<void> createAlert({
    required String petId,
    required double lat,
    required double lng,
    required String lastSeenAddress,
    String? description,
    double rewardAmount = 0,
    String rewardCurrency = 'ZAR',
    double geofenceRadiusKm = 2.0,
  }) async {
    emit(AlertLoading());

    try {
      final result = await _alertRepository.createAlert(
        petId: petId,
        lat: lat,
        lng: lng,
        lastSeenAddress: lastSeenAddress,
        description: description,
        rewardAmount: rewardAmount,
        rewardCurrency: rewardCurrency,
        geofenceRadiusKm: geofenceRadiusKm,
      );

      result.fold(
        (failure) => emit(AlertError(message: failure.message)),
        (_) => emit(const AlertCreated()),
      );
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  /// Load alert details by ID.
  Future<void> loadAlertById(String id) async {
    emit(AlertLoading());

    try {
      final result = await _alertRepository.getAlertById(id);

      result.fold(
        (failure) => emit(AlertError(message: failure.message)),
        (alert) => emit(AlertsLoaded(alerts: [alert])),
      );
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  /// Resolve an alert.
  Future<void> resolveAlert(String id) async {
    final currentState = state;
    emit(AlertLoading());

    try {
      final result = await _alertRepository.resolveAlert(id);

      result.fold(
        (failure) {
          emit(AlertError(message: failure.message));
          emit(currentState);
        },
        (_) => emit(const AlertResolved()),
      );
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }

  /// Cancel an alert.
  Future<void> cancelAlert(String id) async {
    final currentState = state;
    emit(AlertLoading());

    try {
      final result = await _alertRepository.cancelAlert(id);

      result.fold(
        (failure) {
          emit(AlertError(message: failure.message));
          emit(currentState);
        },
        (_) => emit(const AlertCancelled()),
      );
    } catch (e) {
      emit(AlertError(message: e.toString()));
    }
  }
}
