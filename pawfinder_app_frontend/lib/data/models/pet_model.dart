import 'package:equatable/equatable.dart';
import '../../domain/entities/pet.dart';

class PetModel extends Equatable {
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

  const PetModel({
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

  /// Creates a [PetModel] from a JSON map.
  factory PetModel.fromJson(Map<String, dynamic> json) => PetModel(
        id: json['id'] as String,
        ownerId: json['ownerId'] as String,
        name: json['name'] as String,
        species: json['species'] as String,
        breed: json['breed'] as String?,
        color: json['color'] as String?,
        size: json['size'] as String?,
        distinguishingFeatures: json['distinguishingFeatures'] as String?,
        temperamentNotes: json['temperamentNotes'] as String?,
        medicalNeeds: json['medicalNeeds'] as String?,
        photos: (json['photos'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        qrCodeId: json['qrCodeId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'name': name,
        'species': species,
        'breed': breed,
        'color': color,
        'size': size,
        'distinguishingFeatures': distinguishingFeatures,
        'temperamentNotes': temperamentNotes,
        'medicalNeeds': medicalNeeds,
        'photos': photos,
        'qrCodeId': qrCodeId,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Maps this data model to a domain [Pet] entity.
  Pet toEntity() => Pet(
        id: id,
        ownerId: ownerId,
        name: name,
        species: species,
        breed: breed,
        color: color,
        size: size,
        distinguishingFeatures: distinguishingFeatures,
        temperamentNotes: temperamentNotes,
        medicalNeeds: medicalNeeds,
        photos: photos,
        qrCodeId: qrCodeId,
        createdAt: createdAt,
      );

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
