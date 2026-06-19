import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/pet.dart';

/// Repository contract for pet profile operations.
abstract class PetRepository {
  /// List the authenticated user's registered pets.
  Future<Either<Failure, List<Pet>>> getPets();

  /// Create a new pet profile.
  Future<Either<Failure, Pet>> createPet({
    required String name,
    required String species,
    String? breed,
    String? color,
    String? size,
    String? distinguishingFeatures,
    String? temperamentNotes,
    String? medicalNeeds,
    List<String>? photos,
    String? qrCodeId,
  });

  /// Get pet details by ID.
  Future<Either<Failure, Pet>> getPetById(String id);

  /// Update an existing pet profile.
  Future<Either<Failure, Pet>> updatePet({
    required String id,
    required String name,
    required String species,
    String? breed,
    String? color,
    String? size,
    String? distinguishingFeatures,
    String? temperamentNotes,
    String? medicalNeeds,
    List<String>? photos,
  });

  /// Delete a pet profile.
  Future<Either<Failure, void>> deletePet(String id);
}
