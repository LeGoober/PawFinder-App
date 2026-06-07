import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alert_repository.dart';

/// Mock implementation of [AlertRepository] for development.
///
/// Returns three static sample alerts near "Downtown" with varying
/// distances and reward amounts.  Each call is delayed by 1 second.
class AlertRepositoryImpl implements AlertRepository {
  // ---- Mock data ----------------------------------------------------
  static final List<Alert> _mockAlerts = [
    Alert(
      id: 'alt_1001',
      petId: 'pet_2001',
      petName: 'Max',
      species: 'Dog',
      status: AlertStatus.active,
      fuzzedLat: -26.2041, // Johannesburg CBD approx
      fuzzedLng: 28.0473,
      lastSeenAddress: 'Cnr Pritchard & Rissik St, Johannesburg CBD',
      description: 'Brown Labrador, red collar with silver tag. Very friendly.',
      rewardAmount: 1500,
      rewardCurrency: 'ZAR',
      geofenceRadiusKm: 3.0,
      viewCount: 42,
      createdAt: DateTime(2026, 6, 4, 8, 30),
      expiresAt: DateTime(2026, 7, 4, 8, 30),
    ),
    Alert(
      id: 'alt_1002',
      petId: 'pet_2002',
      petName: 'Luna',
      species: 'Cat',
      status: AlertStatus.active,
      fuzzedLat: -26.2010,
      fuzzedLng: 28.0400,
      lastSeenAddress: '75 De Korte St, Braamfontein',
      description: 'Black cat, green eyes, white patch on chest.',
      rewardAmount: 800,
      rewardCurrency: 'ZAR',
      geofenceRadiusKm: 2.0,
      viewCount: 27,
      createdAt: DateTime(2026, 6, 5, 14, 15),
      expiresAt: DateTime(2026, 7, 5, 14, 15),
    ),
    Alert(
      id: 'alt_1003',
      petId: 'pet_2003',
      petName: 'Buddy',
      species: 'Dog',
      status: AlertStatus.active,
      fuzzedLat: -26.2070,
      fuzzedLng: 28.0520,
      lastSeenAddress: '1 Fox St, Maboneng Precinct',
      description:
          'Golden Cocker Spaniel, blue bandana. Answers to "Buddy".',
      rewardAmount: 2000,
      rewardCurrency: 'ZAR',
      geofenceRadiusKm: 5.0,
      viewCount: 63,
      createdAt: DateTime(2026, 6, 3, 10, 0),
      expiresAt: DateTime(2026, 7, 3, 10, 0),
    ),
  ];

  // ---- API ----------------------------------------------------------

  @override
  Future<Either<Failure, Alert>> createAlert({
    required String petId,
    required double lat,
    required double lng,
    required String lastSeenAddress,
    String? description,
    double rewardAmount = 0,
    String rewardCurrency = 'ZAR',
    double geofenceRadiusKm = 2.0,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final now = DateTime.now();
    final alert = Alert(
      id: 'alt_${now.millisecondsSinceEpoch}',
      petId: petId,
      petName: 'New Pet',
      species: 'Unknown',
      status: AlertStatus.active,
      fuzzedLat: lat,
      fuzzedLng: lng,
      lastSeenAddress: lastSeenAddress,
      description: description,
      rewardAmount: rewardAmount,
      rewardCurrency: rewardCurrency,
      geofenceRadiusKm: geofenceRadiusKm,
      viewCount: 0,
      createdAt: now,
      expiresAt: now.add(const Duration(days: 30)),
    );

    return Right(alert);
  }

  @override
  Future<Either<Failure, List<Alert>>> getNearbyAlerts({
    required double lat,
    required double lng,
    double radiusKm = 5.0,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return Right(_mockAlerts);
  }

  @override
  Future<Either<Failure, Alert>> getAlertById(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    final alert = _mockAlerts.firstWhere(
      (a) => a.id == id,
      orElse: () => _mockAlerts.first,
    );
    return Right(alert);
  }

  @override
  Future<Either<Failure, Alert>> resolveAlert(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    final alert = _mockAlerts.firstWhere(
      (a) => a.id == id,
      orElse: () => _mockAlerts.first,
    );
    final resolved = Alert(
      id: alert.id,
      petId: alert.petId,
      petName: alert.petName,
      species: alert.species,
      status: AlertStatus.resolved,
      fuzzedLat: alert.fuzzedLat,
      fuzzedLng: alert.fuzzedLng,
      lastSeenAddress: alert.lastSeenAddress,
      description: alert.description,
      rewardAmount: alert.rewardAmount,
      rewardCurrency: alert.rewardCurrency,
      geofenceRadiusKm: alert.geofenceRadiusKm,
      viewCount: alert.viewCount,
      createdAt: alert.createdAt,
      expiresAt: alert.expiresAt,
    );
    return Right(resolved);
  }

  @override
  Future<Either<Failure, Alert>> cancelAlert(String id) async {
    await Future.delayed(const Duration(seconds: 1));

    final alert = _mockAlerts.firstWhere(
      (a) => a.id == id,
      orElse: () => _mockAlerts.first,
    );
    final cancelled = Alert(
      id: alert.id,
      petId: alert.petId,
      petName: alert.petName,
      species: alert.species,
      status: AlertStatus.cancelled,
      fuzzedLat: alert.fuzzedLat,
      fuzzedLng: alert.fuzzedLng,
      lastSeenAddress: alert.lastSeenAddress,
      description: alert.description,
      rewardAmount: alert.rewardAmount,
      rewardCurrency: alert.rewardCurrency,
      geofenceRadiusKm: alert.geofenceRadiusKm,
      viewCount: alert.viewCount,
      createdAt: alert.createdAt,
      expiresAt: alert.expiresAt,
    );
    return Right(cancelled);
  }
}
