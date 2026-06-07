import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/sighting.dart';
import '../../domain/repositories/sighting_repository.dart';

/// Mock implementation of [SightingRepository] for development.
class SightingRepositoryImpl implements SightingRepository {
  // ---- Mock data ----------------------------------------------------
  static final List<Sighting> _mockSightings = [
    Sighting(
      id: 'sig_5001',
      alertId: 'alt_1001',
      finderId: 'usr_x999',
      fuzzedLat: -26.2035,
      fuzzedLng: 28.0460,
      photoUrls: [
        'https://picsum.photos/id/237/400/300',
        'https://picsum.photos/id/238/400/300',
      ],
      notes: 'Spotted near the library. Looked a bit tired but unharmed.',
      status: SightingStatus.pending,
      createdAt: DateTime(2026, 6, 5, 16, 20),
    ),
    Sighting(
      id: 'sig_5002',
      alertId: 'alt_1002',
      finderId: 'usr_y888',
      fuzzedLat: -26.2005,
      fuzzedLng: 28.0395,
      photoUrls: ['https://picsum.photos/id/200/400/300'],
      notes: 'Black cat with white chest patch seen behind the café.',
      status: SightingStatus.confirmed,
      createdAt: DateTime(2026, 6, 6, 8, 45),
    ),
  ];

  // ---- API ----------------------------------------------------------

  @override
  Future<Either<Failure, Sighting>> reportSighting({
    required String alertId,
    required String finderId,
    required double lat,
    required double lng,
    List<String> photoUrls = const [],
    String? notes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final sighting = Sighting(
      id: 'sig_${DateTime.now().millisecondsSinceEpoch}',
      alertId: alertId,
      finderId: finderId,
      fuzzedLat: lat,
      fuzzedLng: lng,
      photoUrls: photoUrls,
      notes: notes,
      status: SightingStatus.pending,
      createdAt: DateTime.now(),
    );
    return Right(sighting);
  }

  @override
  Future<Either<Failure, List<Sighting>>> getSightingsForAlert(
    String alertId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final filtered =
        _mockSightings.where((s) => s.alertId == alertId).toList();
    return Right(filtered.isEmpty ? _mockSightings : filtered);
  }

  @override
  Future<Either<Failure, Sighting>> confirmSighting(
    String sightingId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    final sighting = _mockSightings.firstWhere(
      (s) => s.id == sightingId,
      orElse: () => _mockSightings.first,
    );
    final confirmed = Sighting(
      id: sighting.id,
      alertId: sighting.alertId,
      finderId: sighting.finderId,
      fuzzedLat: sighting.fuzzedLat,
      fuzzedLng: sighting.fuzzedLng,
      photoUrls: sighting.photoUrls,
      notes: sighting.notes,
      status: SightingStatus.confirmed,
      createdAt: sighting.createdAt,
    );
    return Right(confirmed);
  }

  @override
  Future<Either<Failure, Sighting>> rejectSighting(String sightingId) async {
    await Future.delayed(const Duration(seconds: 1));
    final sighting = _mockSightings.firstWhere(
      (s) => s.id == sightingId,
      orElse: () => _mockSightings.first,
    );
    final rejected = Sighting(
      id: sighting.id,
      alertId: sighting.alertId,
      finderId: sighting.finderId,
      fuzzedLat: sighting.fuzzedLat,
      fuzzedLng: sighting.fuzzedLng,
      photoUrls: sighting.photoUrls,
      notes: sighting.notes,
      status: SightingStatus.rejected,
      createdAt: sighting.createdAt,
    );
    return Right(rejected);
  }
}
