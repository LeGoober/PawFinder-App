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
  /// Returns null if the JSON is missing critical fields (e.g., empty fallback response).
  factory SightingModel.fromJson(Map<String, dynamic> json) {
    // Guard against empty fallback responses
    if (!json.containsKey('id') || json['id'] == null) {
      throw FormatException('SightingModel.fromJson: missing required field "id"');
    }
    return SightingModel(
      id: json['id'] as String,
      alertId: (json['alertId'] ?? '') as String,
      finderId: (json['finderId'] ?? '') as String,
      fuzzedLat: (json['fuzzedLat'] ?? json['latitude'] ?? 0.0) is num
          ? (json['fuzzedLat'] ?? json['latitude'] as num).toDouble()
          : 0.0,
      fuzzedLng: (json['fuzzedLng'] ?? json['longitude'] ?? 0.0) is num
          ? (json['fuzzedLng'] ?? json['longitude'] as num).toDouble()
          : 0.0,
      photoUrls: (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      notes: json['notes'] as String?,
      status: (json['status'] as String?) ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

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
