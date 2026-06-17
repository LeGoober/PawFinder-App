import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../blocs/alert/alert_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/alert_card.dart';
import '../widgets/alert_map_widget.dart';
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
          drawer: _buildDrawer(context),
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
                        // Map area with real alerts
                        if (state.alerts.isNotEmpty)
                          _buildMapArea(state),
                        if (state.alerts.isEmpty)
                          _buildEmptyMapArea(),
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
        onPressed: () => Scaffold.of(context).openDrawer(),
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
          onPressed: () => _showNotifications(context),
        ),
      ],
    );
  }

  /// Build the interactive map with alert markers from loaded state.
  Widget _buildMapArea(AlertsLoaded state) {
    // Compute map center from alert coordinates
    final LatLng center;
    if (state.alerts.isNotEmpty) {
      final avgLat = state.alerts
          .map((a) => a.fuzzedLat)
          .reduce((a, b) => a + b) /
          state.alerts.length;
      final avgLng = state.alerts
          .map((a) => a.fuzzedLng)
          .reduce((a, b) => a + b) /
          state.alerts.length;
      center = LatLng(avgLat, avgLng);
    } else {
      center = const LatLng(-26.2041, 28.0473);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 260,
        child: AlertMapWidget(
          alerts: state.alerts,
          center: center,
          defaultZoom: state.alerts.length == 1 ? 15.0 : 12.0,
          onAlertTap: (alert) => context.push('/alert/${alert.id}'),
        ),
      ),
    );
  }

  /// Fallback map area when no alerts are loaded.
  Widget _buildEmptyMapArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 260,
        child: AlertMapWidget(
          alerts: const [],
          center: const LatLng(-26.2041, 28.0473),
          defaultZoom: 12.0,
        ),
      ),
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
            onTap: () => context.push('/alerts'),
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

  // ── Drawer ─────────────────────────────────────────────────

  Widget _buildDrawer(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final user = authCubit.currentUser;

    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // User header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.pets_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user?.displayName ?? 'Pet Lover',
                    style: AppTypography.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Let\'s bring them home',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Nav items
            const SizedBox(height: 8),
            _DrawerItem(
              icon: Icons.dashboard_rounded,
              label: 'Dashboard',
              onTap: () {
                Navigator.pop(context);
                context.push('/dashboard');
              },
            ),
            _DrawerItem(
              icon: Icons.leaderboard_rounded,
              label: 'Leaderboard',
              onTap: () {
                Navigator.pop(context);
                context.push('/leaderboard');
              },
            ),
            _DrawerItem(
              icon: Icons.notifications_outlined,
              label: 'Notifications',
              onTap: () {
                Navigator.pop(context);
                _showNotifications(context);
              },
            ),
            _DrawerItem(
              icon: Icons.pets_outlined,
              label: 'My Pets',
              onTap: () {
                Navigator.pop(context);
                context.go('/profile');
              },
            ),
            const Spacer(),
            const Divider(color: AppColors.ink100, height: 1),
            _DrawerItem(
              icon: Icons.logout_rounded,
              label: 'Sign Out',
              iconColor: AppColors.danger,
              onTap: () {
                Navigator.pop(context);
                authCubit.logout();
                context.go('/');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ── Notifications Bottom Sheet ─────────────────────────────

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _NotificationSheet(alertCubit: _alertCubit),
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

// ═══════════════════════════════════════════════════════════════
// Drawer item
// ═══════════════════════════════════════════════════════════════

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: iconColor ?? AppColors.ink700,
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w600,
                color: iconColor ?? AppColors.ink900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Notifications bottom sheet
// ═══════════════════════════════════════════════════════════════

class _NotificationSheet extends StatelessWidget {
  final AlertCubit alertCubit;

  const _NotificationSheet({required this.alertCubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.ink300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Recent Alerts',
                  style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push('/alerts');
                  },
                  child: Text(
                    'View all',
                    style: AppTypography.button.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.ink100, height: 1),
          // Alert list
          Flexible(
            child: BlocBuilder<AlertCubit, AlertState>(
              bloc: alertCubit,
              builder: (context, state) {
                if (state is AlertsLoaded) {
                  if (state.alerts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 48, color: AppColors.success),
                          SizedBox(height: 12),
                          Text(
                            'No active alerts nearby',
                            style: TextStyle(color: AppColors.ink500),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: state.alerts.length.clamp(0, 5),
                    separatorBuilder: (_, __) =>
                        const Divider(color: AppColors.ink100, height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final alert = state.alerts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            alert.species == 'dog' ? '🐕' : alert.species == 'cat' ? '🐈' : '🐾',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        title: Text(
                          '${alert.petName} — ${alert.species}',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          alert.lastSeenAddress ?? 'Location unknown',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.ink500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: alert.rewardAmount > 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${alert.rewardCurrency} ${alert.rewardAmount.toStringAsFixed(0)}',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            : null,
                        onTap: () {
                          Navigator.pop(context);
                          context.push('/alert/${alert.id}');
                        },
                      );
                    },
                  );
                }
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
