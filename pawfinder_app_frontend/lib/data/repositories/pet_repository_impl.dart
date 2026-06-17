import 'package:dartz/dartz.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/pet.dart';
import '../../../domain/repositories/pet_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final ApiClient _client;

  PetRepositoryImpl({required ApiClient client}) : _client = client;

  @override
  Future<Either<Failure, List<Pet>>> getPets() async {
    try {
      final json = await _client.get(ApiConstants.pets);
      final list = json as List<dynamic>;
      final pets = list
          .map((e) => PetModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();
      return Right(pets);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final json = await _client.post(ApiConstants.pets, data: {
        'name': name,
        'species': species,
        if (breed != null) 'breed': breed,
        if (color != null) 'color': color,
        if (size != null) 'size': size,
        if (distinguishingFeatures != null)
          'distinguishingFeatures': distinguishingFeatures,
        if (temperamentNotes != null) 'temperamentNotes': temperamentNotes,
        if (medicalNeeds != null) 'medicalNeeds': medicalNeeds,
        if (photos != null) 'photos': photos,
        if (qrCodeId != null) 'qrCodeId': qrCodeId,
      });
      final data = json as Map<String, dynamic>;
      final pet = PetModel.fromJson(data).toEntity();
      return Right(pet);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Pet>> getPetById(String id) async {
    try {
      final json = await _client.get('${ApiConstants.pets}/$id');
      final data = json as Map<String, dynamic>;
      final pet = PetModel.fromJson(data).toEntity();
      return Right(pet);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final json = await _client.put('${ApiConstants.pets}/$id', data: {
        'name': name,
        'species': species,
        if (breed != null) 'breed': breed,
        if (color != null) 'color': color,
        if (size != null) 'size': size,
        if (distinguishingFeatures != null)
          'distinguishingFeatures': distinguishingFeatures,
        if (temperamentNotes != null) 'temperamentNotes': temperamentNotes,
        if (medicalNeeds != null) 'medicalNeeds': medicalNeeds,
        if (photos != null) 'photos': photos,
      });
      final data = json as Map<String, dynamic>;
      final pet = PetModel.fromJson(data).toEntity();
      return Right(pet);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePet(String id) async {
    try {
      await _client.delete('${ApiConstants.pets}/$id');
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
