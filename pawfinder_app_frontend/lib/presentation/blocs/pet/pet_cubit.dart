import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/pet.dart';
import '../../../domain/repositories/pet_repository.dart';
import '../../../domain/repositories/alert_repository.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetRepository _petRepository;
  final AlertRepository _alertRepository;

  PetCubit({
    required PetRepository petRepository,
    required AlertRepository alertRepository,
  })  : _petRepository = petRepository,
        _alertRepository = alertRepository,
        super(const PetInitial());

  /// Load the current user's registered pets.
  Future<void> loadPets() async {
    emit(const PetLoading());

    try {
      final result = await _petRepository.getPets();

      result.fold(
        (failure) => emit(PetError(message: failure.message)),
        (pets) => emit(PetsLoaded(pets: pets)),
      );
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  /// Create a new pet profile on the backend.
  Future<void> createPet({
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
    emit(const PetLoading());

    try {
      final result = await _petRepository.createPet(
        name: name,
        species: species,
        breed: breed,
        color: color,
        size: size,
        distinguishingFeatures: distinguishingFeatures,
        temperamentNotes: temperamentNotes,
        medicalNeeds: medicalNeeds,
        photos: photos,
      );

      result.fold(
        (failure) => emit(PetError(message: failure.message)),
        (Pet pet) => emit(PetCreated(pet: pet)),
      );
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }

  /// Create an alert for a pet and submit to backend.
  Future<void> createAlert({
    required String petId,
    required double lat,
    required double lng,
    required String lastSeenAddress,
    String? description,
    double rewardAmount = 0,
    String rewardCurrency = 'ZAR',
    double geofenceRadiusKm = 2.0,
  }) async {
    emit(const PetLoading());

    try {
      final result = await _alertRepository.createAlert(
        petId: petId,
        lat: lat,
        lng: lng,
        lastSeenAddress: lastSeenAddress,
        description: description,
        rewardAmount: rewardAmount,
        rewardCurrency: rewardCurrency,
        geofenceRadiusKm: geofenceRadiusKm,
      );

      result.fold(
        (failure) => emit(PetError(message: failure.message)),
        (_) => emit(const PetCreated(
          pet: Pet(
            id: '',
            ownerId: '',
            name: 'alert_created',
            species: '',
            createdAt: DateTime(2024),
          ),
        )),
      );
    } catch (e) {
      emit(PetError(message: e.toString()));
    }
  }
}
