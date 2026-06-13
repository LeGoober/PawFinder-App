import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../blocs/alert/alert_cubit.dart';
import '../widgets/alert_card.dart';
import '../widgets/info_banner.dart';
import '../widgets/glass_surface.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/textured_background.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      child: TexturedBackground(
        mode: BackgroundMode.warmGlass,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: _buildGlassAppBar(context),
          body: BlocBuilder<AlertCubit, AlertState>(
            bloc: _alertCubit,
            builder: (context, state) {
              if (state is AlertLoading) {
                return const SkeletonListLoader(itemCount: 3);
              }

              if (state is AlertsLoaded) {
                return RefreshIndicator(
                  onRefresh: () => _alertCubit.loadAlerts(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Warning banner
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: InfoBanner(
                            message:
                                '${state.alerts.length} pet${state.alerts.length == 1 ? '' : 's'} missing near you',
                            type: InfoBannerType.warning,
                          ),
                        ),
                        AppSpacing.md,
                        // Map area
                        _buildGlassMapArea(),
                        AppSpacing.lg,
                        // Section header
                        _buildSectionHeader('Nearby Alerts', 'See all'),
                        AppSpacing.sm,
                        // Alert cards from API
                        ...state.alerts.map(
                          (alert) => AlertCard.fromAlert(
                            alert: alert,
                            onTap: () => context.push('/alert/${alert.id}'),
                          ),
                        ),
                        if (state.alerts.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Text(
                                'No alerts nearby. Check back later!',
                                style: TextStyle(color: AppColors.ink500),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }

              if (state is AlertError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: AppColors.danger),
                        const SizedBox(height: 12),
                        Text(
                          'Failed to load alerts',
                          style: AppTypography.h3,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.message,
                          style: AppTypography.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _alertCubit.loadAlerts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
          floatingActionButton: _buildReportPill(context),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        'PawFinder',
        style: AppTypography.h2.copyWith(
          color: AppColors.ink900,
          fontWeight: FontWeight.w700,
        ),
      ),
      leading: IconButton(
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.ink900.withValues(alpha: 0.04),
          ),
          child:
              const Icon(Icons.menu_rounded, color: AppColors.ink900, size: 20),
        ),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildGlassMapArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassSurface(
        borderRadius: 24,
        blurSigma: 6,
        elevation: 4,
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0x1AE8612D),
                    Color(0x0D5B9A8B),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.map_outlined,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Interactive Map Coming Soon',
              style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap to view lost pets near your location',
              style: AppTypography.body.copyWith(
                color: AppColors.ink500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, AppColors.secondary],
              ),
            ),
          ),
          Text(
            title,
            style: AppTypography.h2.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primary.withValues(alpha: 0.06),
              ),
              child: Text(
                action,
                style: AppTypography.label.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportPill(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/create-alert'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              'Report Missing Pet',
              style: AppTypography.button.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
