part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final int totalReunited;
  final int activeAlerts;
  final int resolvedAlerts;
  final String avgResolutionTime;
  final List<_MockRescuer> topRescuers;
  final List<_MockStory> recentStories;

  const DashboardLoaded({
    required this.totalReunited,
    required this.activeAlerts,
    required this.resolvedAlerts,
    required this.avgResolutionTime,
    required this.topRescuers,
    required this.recentStories,
  });

  @override
  List<Object?> get props => [
        totalReunited,
        activeAlerts,
        resolvedAlerts,
        avgResolutionTime,
        topRescuers,
        recentStories,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object?> get props => [message];
}
