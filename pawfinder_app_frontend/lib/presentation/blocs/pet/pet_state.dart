part of 'pet_cubit.dart';

abstract class PetState extends Equatable {
  const PetState();

  @override
  List<Object?> get props => [];
}

class PetInitial extends PetState {
  const PetInitial();
}

class PetLoading extends PetState {
  const PetLoading();
}

class PetsLoaded extends PetState {
  final List<Pet> pets;

  const PetsLoaded({required this.pets});

  @override
  List<Object?> get props => [pets];
}

class PetCreated extends PetState {
  final Pet pet;

  const PetCreated({required this.pet});

  @override
  List<Object?> get props => [pet];
}

class PetError extends PetState {
  final String message;

  const PetError({required this.message});

  @override
  List<Object?> get props => [message];
}
