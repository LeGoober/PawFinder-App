import 'package:equatable/equatable.dart';

/// Possible alert statuses.
enum AlertStatus { active, resolved, cancelled, expired }

/// Domain entity representing a lost-pet alert.
class Alert extends Equatable {
  final String id;
  final String petId;
  final String petName;
  final String species;
  final AlertStatus status;
  final double fuzzedLat;
  final double fuzzedLng;
  final String? lastSeenAddress;
  final String? description;
  final double rewardAmount;
  final String rewardCurrency;
  final double geofenceRadiusKm;
  final int viewCount;
  final DateTime createdAt;
  final DateTime expiresAt;

  const Alert({
    required this.id,
    required this.petId,
    required this.petName,
    required this.species,
    required this.status,
    required this.fuzzedLat,
    required this.fuzzedLng,
    this.lastSeenAddress,
    this.description,
    this.rewardAmount = 0,
    this.rewardCurrency = 'ZAR',
    this.geofenceRadiusKm = 2.0,
    this.viewCount = 0,
    required this.createdAt,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [
        id,
        petId,
        petName,
        species,
        status,
        fuzzedLat,
        fuzzedLng,
        lastSeenAddress,
        description,
        rewardAmount,
        rewardCurrency,
        geofenceRadiusKm,
        viewCount,
        createdAt,
        expiresAt,
      ];
}
