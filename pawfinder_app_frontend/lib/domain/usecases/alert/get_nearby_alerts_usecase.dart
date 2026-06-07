import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/alert.dart';
import '../../repositories/alert_repository.dart';

/// Params for the [GetNearbyAlertsUseCase].
class GetNearbyAlertsParams extends Equatable {
  final double lat;
  final double lng;
  final double radiusKm;

  const GetNearbyAlertsParams({
    required this.lat,
    required this.lng,
    this.radiusKm = 5.0,
  });

  @override
  List<Object?> get props => [lat, lng, radiusKm];
}

/// Fetches lost-pet alerts near a geographic point.
class GetNearbyAlertsUseCase
    extends UseCase<List<Alert>, GetNearbyAlertsParams> {
  final AlertRepository _repository;

  GetNearbyAlertsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Alert>>> call(GetNearbyAlertsParams params) {
    return _repository.getNearbyAlerts(
      lat: params.lat,
      lng: params.lng,
      radiusKm: params.radiusKm,
    );
  }
}
