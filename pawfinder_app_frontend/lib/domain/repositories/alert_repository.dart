import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/alert.dart';

/// Abstract repository for alert operations.
abstract class AlertRepository {
  /// Creates a new lost-pet alert.
  Future<Either<Failure, Alert>> createAlert({
    required String petId,
    required double lat,
    required double lng,
    required String lastSeenAddress,
    String? description,
    double rewardAmount = 0,
    String rewardCurrency = 'ZAR',
    double geofenceRadiusKm = 2.0,
  });

  /// Fetches nearby alerts within [radiusKm] of ([lat], [lng]).
  Future<Either<Failure, List<Alert>>> getNearbyAlerts({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  });

  /// Fetches a single alert by its [id].
  Future<Either<Failure, Alert>> getAlertById(String id);

  /// Marks an alert as resolved (pet found).
  Future<Either<Failure, Alert>> resolveAlert(String id);

  /// Cancels an active alert.
  Future<Either<Failure, Alert>> cancelAlert(String id);
}
