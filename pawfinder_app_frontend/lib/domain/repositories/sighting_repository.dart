import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/sighting.dart';

/// Abstract repository for sighting operations.
abstract class SightingRepository {
  /// Reports a new sighting for an active alert.
  Future<Either<Failure, Sighting>> reportSighting({
    required String alertId,
    required String finderId,
    required double lat,
    required double lng,
    List<String> photoUrls = const [],
    String? notes,
  });

  /// Fetches all sightings for a given alert.
  Future<Either<Failure, List<Sighting>>> getSightingsForAlert(
    String alertId,
  );

  /// Confirms a sighting as valid by the alert owner.
  Future<Either<Failure, Sighting>> confirmSighting(String sightingId);

  /// Rejects a sighting by the alert owner.
  Future<Either<Failure, Sighting>> rejectSighting(String sightingId);
}
