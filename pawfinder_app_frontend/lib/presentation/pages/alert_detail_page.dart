import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../blocs/alert/alert_cubit.dart';
import '../blocs/sighting/sighting_cubit.dart';
import '../helpers/time_ago.dart';
import '../widgets/app_button.dart';
import '../widgets/info_banner.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/status_badge.dart';

class AlertDetailPage extends StatefulWidget {
  final String alertId;

  const AlertDetailPage({super.key, required this.alertId});

  @override
  State<AlertDetailPage> createState() => _AlertDetailPageState();
}

class _AlertDetailPageState extends State<AlertDetailPage> {
  late final AlertCubit _alertCubit;
  late final SightingCubit _sightingCubit;

  @override
  void initState() {
    super.initState();
    _alertCubit = AlertCubit(alertRepository: getIt());
    _sightingCubit = SightingCubit(sightingRepository: getIt());
    _alertCubit.loadAlertById(widget.alertId);
    _sightingCubit.loadSightings(widget.alertId);
  }

  @override
  void dispose() {
    _alertCubit.close();
    _sightingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _alertCubit),
        BlocProvider.value(value: _sightingCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<AlertCubit, AlertState>(
          bloc: _alertCubit,
          builder: (context, state) {
            if (state is AlertLoading) {
              return const SkeletonListLoader(itemCount: 1);
            }

            if (state is AlertsLoaded && state.alerts.isNotEmpty) {
              final alert = state.alerts.first;
              return _buildDetailView(context, alert);
            }

            if (state is AlertError) {
              return _buildErrorView(context);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, alert) {
    final currencySymbol = alert.rewardCurrency == 'ZAR' ? 'R' : '\$';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(),
                _buildAppBar(context),
                AppSpacing.lg,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InfoBanner(
                        message: 'Your contact info is hidden from finders.',
                        type: InfoBannerType.info,
                      ),
                      AppSpacing.lg,
                      // Pet name + species
                      Text(alert.petName, style: AppTypography.h1),
                      AppSpacing.xs,
                      Row(
                        children: [
                          Text(alert.species, style: AppTypography.bodyLarge),
                          const SizedBox(width: 8),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.ink300,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Missing ${formatTimeAgo(alert.createdAt)}',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                      AppSpacing.md,
                      StatusBadge(
                        text: alert.status.name.toUpperCase(),
                        type: alert.status.name == 'active'
                            ? StatusType.active
                            : StatusType.resolved,
                      ),
                      AppSpacing.xl,
                      // Description
                      if (alert.description != null &&
                          alert.description!.isNotEmpty) ...[
                        Text('Description', style: AppTypography.h3),
                        AppSpacing.sm,
                        Text(
                          alert.description!,
                          style: AppTypography.body.copyWith(
                            color: AppColors.ink700,
                          ),
                        ),
                        AppSpacing.xl,
                      ],
                      // Location
                      if (alert.lastSeenAddress != null &&
                          alert.lastSeenAddress!.isNotEmpty) ...[
                        Text('Last Seen', style: AppTypography.h3),
                        AppSpacing.sm,
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 18, color: AppColors.danger),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                alert.lastSeenAddress!,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.ink700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.xl,
                      ],
                      // Reward
                      if (alert.rewardAmount > 0) ...[
                        _buildRewardCard(
                            currencySymbol, alert.rewardAmount.toStringAsFixed(0)),
                        AppSpacing.xl,
                      ],
                      // Sightings section
                      Text('Recent Sightings', style: AppTypography.h3),
                      AppSpacing.md,
                      BlocBuilder<SightingCubit, SightingState>(
                        bloc: _sightingCubit,
                        builder: (context, sightingState) {
                          if (sightingState is SightingLoading) {
                            return const SkeletonListLoader(itemCount: 1);
                          }
                          if (sightingState is SightingsLoaded) {
                            if (sightingState.sightings.isEmpty) {
                              return Text(
                                'No sightings reported yet.',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.ink500,
                                ),
                              );
                            }
                            return Column(
                              children: sightingState.sightings
                                  .map((s) => _buildSightingItem(s))
                                  .toList(),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      AppSpacing.xxl,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildBottomAction(context),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Center(
        child: Icon(Icons.pets, size: 80,
            color: AppColors.primary.withValues(alpha: 0.3)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.ink900.withValues(alpha: 0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () => context.pop(),
              color: AppColors.ink900,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share_outlined,
                        size: 20, color: AppColors.ink700),
                    const SizedBox(width: 8),
                    Text('Share', style: AppTypography.body),
                  ],
                ),
              ),
            ],
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink900.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.more_horiz,
                  size: 20, color: AppColors.ink900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(String symbol, String amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.rewardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.reward.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.reward,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.card_giftcard, color: AppColors.rewardDark),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$symbol$amount Reward',
                  style: AppTypography.h3.copyWith(color: AppColors.rewardDark),
                ),
                Text(
                  'Offered for safe return. Held securely in escrow.',
                  style:
                      AppTypography.bodySmall.copyWith(color: AppColors.rewardDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSightingItem(sighting) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ink100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.visibility,
                color: AppColors.secondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sighting reported',
                  style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${formatTimeAgo(sighting.createdAt)} \u2022 ${sighting.status.name}',
                  style: AppTypography.caption,
                ),
                if (sighting.notes != null && sighting.notes!.isNotEmpty)
                  Text(
                    sighting.notes!,
                    style: AppTypography.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.ink900.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: AppButton(
          text: 'I Saw This Pet',
          type: AppButtonType.success,
          onPressed: () {
            context.push('/report');
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.danger),
          const SizedBox(height: 12),
          Text('Failed to load alert', style: AppTypography.h3),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => _alertCubit.loadAlertById(widget.alertId),
            child: const Text('Retry'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Go back'),
          ),
        ],
      ),
    );
  }
}
