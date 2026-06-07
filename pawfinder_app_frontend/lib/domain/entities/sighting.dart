import 'package:equatable/equatable.dart';

/// Possible sighting statuses.
enum SightingStatus { pending, confirmed, rejected }

/// Domain entity representing a reported sighting of a lost pet.
class Sighting extends Equatable {
  final String id;
  final String alertId;
  final String finderId;
  final double fuzzedLat;
  final double fuzzedLng;
  final List<String> photoUrls;
  final String? notes;
  final SightingStatus status;
  final DateTime createdAt;

  const Sighting({
    required this.id,
    required this.alertId,
    required this.finderId,
    required this.fuzzedLat,
    required this.fuzzedLng,
    this.photoUrls = const [],
    this.notes,
    this.status = SightingStatus.pending,
    required this.createdAt,
  });

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
