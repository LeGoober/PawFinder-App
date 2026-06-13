import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../blocs/alert/alert_cubit.dart';
import '../widgets/alert_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/skeleton_loader.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  late final AlertCubit _alertCubit;

  @override
  void initState() {
    super.initState();
    _alertCubit = AlertCubit(
      alertRepository: getIt(),
      locationService: getIt(),
    );
    _alertCubit.loadAlerts();
  }

  @override
  void dispose() {
    _alertCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _alertCubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(
            'Alerts',
            style: AppTypography.h2.copyWith(color: AppColors.ink900),
          ),
          actions: [
            _buildFilterButton(),
          ],
        ),
        body: BlocBuilder<AlertCubit, AlertState>(
          bloc: _alertCubit,
          builder: (context, state) {
            if (state is AlertLoading) {
              return const SkeletonListLoader(itemCount: 5);
            }

            if (state is AlertsLoaded) {
              if (state.alerts.isEmpty) {
                return const EmptyState(
                  icon: Icons.pets_outlined,
                  title: 'No alerts nearby',
                  subtitle: 'No missing pets reported in your area.',
                );
              }

              return RefreshIndicator(
                onRefresh: () => _alertCubit.loadAlerts(),
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 100,
                  ),
                  itemCount: state.alerts.length,
                  itemBuilder: (context, index) {
                    final alert = state.alerts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AlertCard.fromAlert(
                        alert: alert,
                        onTap: () {
                          // Navigate to alert detail
                        },
                      ),
                    );
                  },
                ),
              );
            }

            if (state is AlertError) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: EmptyState(
                  icon: Icons.error_outline,
                  title: 'Failed to load alerts',
                  subtitle: state.message,
                  actionText: 'Retry',
                  onAction: () => _alertCubit.loadAlerts(),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return PopupMenuButton<String>(
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.filter_list, color: AppColors.primary, size: 20),
      ),
      onSelected: (value) {
        // Implement filter logic
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'all',
          child: Text('All species'),
        ),
        const PopupMenuItem(
          value: 'dog',
          child: Text('Dogs only'),
        ),
        const PopupMenuItem(
          value: 'cat',
          child: Text('Cats only'),
        ),
        const PopupMenuItem(
          value: 'with_reward',
          child: Text('With reward'),
        ),
      ],
    );
  }
}
