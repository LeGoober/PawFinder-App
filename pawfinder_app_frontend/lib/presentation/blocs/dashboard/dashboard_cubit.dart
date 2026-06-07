import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      const DashboardLoaded(
        totalReunited: 1247,
        activeAlerts: 42,
        resolvedAlerts: 38,
        avgResolutionTime: '18h',
        topRescuers: [
          _MockRescuer(name: 'Emily R.', reunions: 47, badgeLevel: 'Diamond'),
          _MockRescuer(name: 'Marcus T.', reunions: 32, badgeLevel: 'Platinum'),
          _MockRescuer(name: 'Jordan L.', reunions: 28, badgeLevel: 'Gold'),
        ],
        recentStories: [
          _MockStory(
            petName: 'Buddy',
            description:
                'Reunited after 3 days thanks to a neighbour who saw the alert',
            imageUrl: '',
          ),
        ],
      ),
    );
  }
}

class _MockRescuer {
  final String name;
  final int reunions;
  final String badgeLevel;

  const _MockRescuer({
    required this.name,
    required this.reunions,
    required this.badgeLevel,
  });
}

class _MockStory {
  final String petName;
  final String description;
  final String imageUrl;

  const _MockStory({
    required this.petName,
    required this.description,
    required this.imageUrl,
  });
}
