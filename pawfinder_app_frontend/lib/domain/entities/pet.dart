import 'package:equatable/equatable.dart';

/// Domain entity representing a registered pet.
class Pet extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String species;
  final String? breed;
  final String? color;
  final String? size;
  final String? distinguishingFeatures;
  final String? temperamentNotes;
  final String? medicalNeeds;
  final List<String> photos;
  final String? qrCodeId;
  final DateTime createdAt;

  const Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    this.breed,
    this.color,
    this.size,
    this.distinguishingFeatures,
    this.temperamentNotes,
    this.medicalNeeds,
    this.photos = const [],
    this.qrCodeId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        species,
        breed,
        color,
        size,
        distinguishingFeatures,
        temperamentNotes,
        medicalNeeds,
        photos,
        qrCodeId,
        createdAt,
      ];
}
