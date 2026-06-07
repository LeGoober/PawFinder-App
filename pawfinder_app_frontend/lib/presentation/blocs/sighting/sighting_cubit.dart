import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sighting_state.dart';

class SightingCubit extends Cubit<SightingState> {
  SightingCubit() : super(SightingInitial());

  Future<void> loadSightings(String alertId) async {
    emit(SightingLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      const SightingsLoaded(
        sightings: [
          _MockSighting(
            id: 's1',
            location: 'Oak Street Park',
            timeAgo: '15 min ago',
            reportedBy: 'Sarah M.',
          ),
          _MockSighting(
            id: 's2',
            location: 'Near the library',
            timeAgo: '1 hour ago',
            reportedBy: 'James K.',
          ),
        ],
      ),
    );
  }

  Future<void> reportSighting(Map<String, dynamic> data) async {
    emit(SightingLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(const SightingReported());
  }
}

class _MockSighting {
  final String id;
  final String location;
  final String timeAgo;
  final String reportedBy;

  const _MockSighting({
    required this.id,
    required this.location,
    required this.timeAgo,
    required this.reportedBy,
  });
}
