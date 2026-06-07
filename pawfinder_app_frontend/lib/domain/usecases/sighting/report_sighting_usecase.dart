import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/errors/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/sighting.dart';
import '../../repositories/sighting_repository.dart';

/// Params for the [ReportSightingUseCase].
class ReportSightingParams extends Equatable {
  final String alertId;
  final String finderId;
  final double lat;
  final double lng;
  final List<String> photoUrls;
  final String? notes;

  const ReportSightingParams({
    required this.alertId,
    required this.finderId,
    required this.lat,
    required this.lng,
    this.photoUrls = const [],
    this.notes,
  });

  @override
  List<Object?> get props => [alertId, finderId, lat, lng, photoUrls, notes];
}

/// Reports a sighting of a lost pet.
class ReportSightingUseCase extends UseCase<Sighting, ReportSightingParams> {
  final SightingRepository _repository;

  ReportSightingUseCase(this._repository);

  @override
  Future<Either<Failure, Sighting>> call(ReportSightingParams params) {
    return _repository.reportSighting(
      alertId: params.alertId,
      finderId: params.finderId,
      lat: params.lat,
      lng: params.lng,
      photoUrls: params.photoUrls,
      notes: params.notes,
    );
  }
}
