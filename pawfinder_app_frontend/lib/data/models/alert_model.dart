import 'package:equatable/equatable.dart';
import '../../domain/entities/alert.dart';
import '../../domain/entities/alert.dart' as domain show AlertStatus;

class AlertModel extends Equatable {
  final String id;
  final String petId;
  final String petName;
  final String species;
  final String status;
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

  const AlertModel({
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

  /// Creates an [AlertModel] from a JSON map.
  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        id: json['id'] as String,
        petId: json['petId'] as String,
        petName: json['petName'] as String,
        species: json['species'] as String,
        status: json['status'] as String,
        fuzzedLat: (json['fuzzedLat'] as num).toDouble(),
        fuzzedLng: (json['fuzzedLng'] as num).toDouble(),
        lastSeenAddress: json['lastSeenAddress'] as String?,
        description: json['description'] as String?,
        rewardAmount: (json['rewardAmount'] as num?)?.toDouble() ?? 0,
        rewardCurrency: json['rewardCurrency'] as String? ?? 'ZAR',
        geofenceRadiusKm:
            (json['geofenceRadiusKm'] as num?)?.toDouble() ?? 2.0,
        viewCount: json['viewCount'] as int? ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        expiresAt: DateTime.parse(json['expiresAt'] as String),
      );

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'petId': petId,
        'petName': petName,
        'species': species,
        'status': status,
        'fuzzedLat': fuzzedLat,
        'fuzzedLng': fuzzedLng,
        'lastSeenAddress': lastSeenAddress,
        'description': description,
        'rewardAmount': rewardAmount,
        'rewardCurrency': rewardCurrency,
        'geofenceRadiusKm': geofenceRadiusKm,
        'viewCount': viewCount,
        'createdAt': createdAt.toIso8601String(),
        'expiresAt': expiresAt.toIso8601String(),
      };

  /// Parses the status string to a domain [AlertStatus] enum.
  domain.AlertStatus _parseStatus() {
    switch (status) {
      case 'active':
        return domain.AlertStatus.active;
      case 'resolved':
        return domain.AlertStatus.resolved;
      case 'cancelled':
        return domain.AlertStatus.cancelled;
      case 'expired':
        return domain.AlertStatus.expired;
      default:
        return domain.AlertStatus.active;
    }
  }

  /// Maps this data model to a domain [Alert] entity.
  Alert toEntity() => Alert(
        id: id,
        petId: petId,
        petName: petName,
        species: species,
        status: _parseStatus(),
        fuzzedLat: fuzzedLat,
        fuzzedLng: fuzzedLng,
        lastSeenAddress: lastSeenAddress,
        description: description,
        rewardAmount: rewardAmount,
        rewardCurrency: rewardCurrency,
        geofenceRadiusKm: geofenceRadiusKm,
        viewCount: viewCount,
        createdAt: createdAt,
        expiresAt: expiresAt,
      );

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
