import 'package:equatable/equatable.dart';
import '../../domain/entities/sighting.dart';
import '../../domain/entities/sighting.dart' as domain show SightingStatus;

class SightingModel extends Equatable {
  final String id;
  final String alertId;
  final String finderId;
  final double fuzzedLat;
  final double fuzzedLng;
  final List<String> photoUrls;
  final String? notes;
  final String status;
  final DateTime createdAt;

  const SightingModel({
    required this.id,
    required this.alertId,
    required this.finderId,
    required this.fuzzedLat,
    required this.fuzzedLng,
    this.photoUrls = const [],
    this.notes,
    this.status = 'pending',
    required this.createdAt,
  });

  /// Creates a [SightingModel] from a JSON map.
  factory SightingModel.fromJson(Map<String, dynamic> json) =>
      SightingModel(
        id: json['id'] as String,
        alertId: json['alertId'] as String,
        finderId: json['finderId'] as String,
        fuzzedLat: (json['fuzzedLat'] as num).toDouble(),
        fuzzedLng: (json['fuzzedLng'] as num).toDouble(),
        photoUrls: (json['photoUrls'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        notes: json['notes'] as String?,
        status: json['status'] as String? ?? 'pending',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'alertId': alertId,
        'finderId': finderId,
        'fuzzedLat': fuzzedLat,
        'fuzzedLng': fuzzedLng,
        'photoUrls': photoUrls,
        'notes': notes,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Parses the status string to a domain [SightingStatus] enum.
  domain.SightingStatus _parseStatus() {
    switch (status) {
      case 'confirmed':
        return domain.SightingStatus.confirmed;
      case 'rejected':
        return domain.SightingStatus.rejected;
      default:
        return domain.SightingStatus.pending;
    }
  }

  /// Maps this data model to a domain [Sighting] entity.
  Sighting toEntity() => Sighting(
        id: id,
        alertId: alertId,
        finderId: finderId,
        fuzzedLat: fuzzedLat,
        fuzzedLng: fuzzedLng,
        photoUrls: photoUrls,
        notes: notes,
        status: _parseStatus(),
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [
        id,
        alertId,
        finderId,
        fuzzedLat,
        fuzzedLng,
        photoUrls,
        notes,
        status,
        createdAt,
      ];
}
