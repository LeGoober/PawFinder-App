import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/alert.dart';
import '../../repositories/alert_repository.dart';

/// Params for the [CreateAlertUseCase].
class CreateAlertParams extends Equatable {
  final String petId;
  final double lat;
  final double lng;
  final String lastSeenAddress;
  final String? description;
  final double rewardAmount;
  final String rewardCurrency;
  final double geofenceRadiusKm;

  const CreateAlertParams({
    required this.petId,
    required this.lat,
    required this.lng,
    required this.lastSeenAddress,
    this.description,
    this.rewardAmount = 0,
    this.rewardCurrency = 'ZAR',
    this.geofenceRadiusKm = 2.0,
  });

  @override
  List<Object?> get props => [
        petId,
        lat,
        lng,
        lastSeenAddress,
        description,
        rewardAmount,
        rewardCurrency,
        geofenceRadiusKm,
      ];
}

/// Creates a new lost-pet alert.
class CreateAlertUseCase extends UseCase<Alert, CreateAlertParams> {
  final AlertRepository _repository;

  CreateAlertUseCase(this._repository);

  @override
  Future<Either<Failure, Alert>> call(CreateAlertParams params) {
    return _repository.createAlert(
      petId: params.petId,
      lat: params.lat,
      lng: params.lng,
      lastSeenAddress: params.lastSeenAddress,
      description: params.description,
      rewardAmount: params.rewardAmount,
      rewardCurrency: params.rewardCurrency,
      geofenceRadiusKm: params.geofenceRadiusKm,
    );
  }
}
