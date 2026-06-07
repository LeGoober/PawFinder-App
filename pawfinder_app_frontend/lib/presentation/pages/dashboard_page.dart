import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/stat_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Community Impact',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '\uD83C\uDF89 1,247 pets reunited \uD83C\uDF89',
                style: AppTypography.h1.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            AppSpacing.xl,
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Active',
                    value: '42',
                    color: AppColors.danger,
                  ),
                ),
                AppSpacing.md,
                Expanded(
                  child: StatCard(
                    title: 'Resolved',
                    value: '38',
                    color: AppColors.success,
                  ),
                ),
                AppSpacing.md,
                Expanded(
                  child: StatCard(
                    title: 'Avg Time',
                    value: '18h',
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            AppSpacing.xl,
            Text('Trend Chart', style: AppTypography.h2),
            AppSpacing.md,
            _buildTrendChartPlaceholder(),
            AppSpacing.xl,
            Text('Recent Success Stories', style: AppTypography.h2),
            AppSpacing.md,
            _buildStoryCard(),
            AppSpacing.xl,
            Text(
              '\uD83C\uDFC6 Top Rescuers',
              style: AppTypography.h2,
            ),
            AppSpacing.md,
            _buildLeaderboard(),
            AppSpacing.xxl,
          ],
        ),
      ),
    );
  }

  Widget _buildTrendChartPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.ink100),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              size: AppSpacing.avatarSize,
              color: AppColors.ink300,
            ),
            AppSpacing.sm,
            Text(
              'Chart loading...',
              style: AppTypography.body.copyWith(
                color: AppColors.ink500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.ink100),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink900.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Center(
              child: Text('\uD83D\uDC36', style: TextStyle(fontSize: 32)),
            ),
          ),
          AppSpacing.md,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buddy found!', style: AppTypography.h3),
                AppSpacing.xs,
                Text(
                  'Reunited after 3 days thanks to a neighbour who saw the alert.',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    final rescuers = [
      _LeaderEntry(
        rank: 1,
        name: 'Emily R.',
        reunions: 47,
        badge: 'Diamond',
        medal: Icons.emoji_events,
        medalColor: Color(0xFFFFD700),
      ),
      _LeaderEntry(
        rank: 2,
        name: 'Marcus T.',
        reunions: 32,
        badge: 'Platinum',
        medal: Icons.emoji_events,
        medalColor: Color(0xFFC0C0C0),
      ),
      _LeaderEntry(
        rank: 3,
        name: 'Jordan L.',
        reunions: 28,
        badge: 'Gold',
        medal: Icons.emoji_events,
        medalColor: Color(0xFFCD7F32),
      ),
    ];

    return Column(
      children: rescuers.map((rescuer) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius:
                  BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.ink100),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Icon(
                    rescuer.medal,
                    size: 24,
                    color: rescuer.medalColor,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.ink500,
                  ),
                ),
                AppSpacing.md,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rescuer.name,
                        style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${rescuer.reunions} reunions',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    rescuer.badge,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LeaderEntry {
  final int rank;
  final String name;
  final int reunions;
  final String badge;
  final IconData medal;
  final Color medalColor;

  const _LeaderEntry({
    required this.rank,
    required this.name,
    required this.reunions,
    required this.badge,
    required this.medal,
    required this.medalColor,
  });
}
