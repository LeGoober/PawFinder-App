import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'alert_state.dart';

class AlertCubit extends Cubit<AlertState> {
  AlertCubit() : super(AlertInitial());

  Future<void> loadAlerts() async {
    emit(AlertLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      const AlertsLoaded(
        alerts: [
          _MockAlert(
            id: '1',
            petName: 'Max',
            species: 'Dog',
            breed: 'Golden Retriever',
            timeMissing: '2 hours ago',
            distance: '0.5 km',
          ),
          _MockAlert(
            id: '2',
            petName: 'Luna',
            species: 'Cat',
            breed: 'Tabby',
            timeMissing: '30 min ago',
            distance: '1.2 km',
          ),
          _MockAlert(
            id: '3',
            petName: 'Rocky',
            species: 'Dog',
            breed: 'German Shepherd',
            timeMissing: '1 hour ago',
            distance: '0.8 km',
          ),
        ],
      ),
    );
  }

  Future<void> createAlert(Map<String, dynamic> data) async {
    emit(AlertLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(const AlertCreated());
  }
}

class _MockAlert {
  final String id;
  final String petName;
  final String species;
  final String breed;
  final String timeMissing;
  final String distance;

  const _MockAlert({
    required this.id,
    required this.petName,
    required this.species,
    required this.breed,
    required this.timeMissing,
    required this.distance,
  });
}
