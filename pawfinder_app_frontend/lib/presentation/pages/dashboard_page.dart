import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/glass_surface.dart';
import '../widgets/textured_background.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TexturedBackground(
      mode: BackgroundMode.warmGlass,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Community Impact',
            style: AppTypography.h2.copyWith(color: AppColors.ink900),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero stat — glass panel
              GlassSurface(
                blurSigma: 10,
                borderRadius: 24,
                elevation: 4,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      '\uD83C\uDF89',
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1,247 pets reunited',
                      style: AppTypography.displaySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thanks to our amazing community',
                      style: AppTypography.body.copyWith(
                        color: AppColors.ink500,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.xl,
              // Stat cards row — three glass cards
              Row(
                children: [
                  Expanded(
                    child: _GlassStatCard(
                      title: 'Active',
                      value: '42',
                      icon: Icons.search_rounded,
                      color: AppColors.danger,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GlassStatCard(
                      title: 'Resolved',
                      value: '38',
                      icon: Icons.check_circle_rounded,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _GlassStatCard(
                      title: 'Avg Time',
                      value: '18h',
                      icon: Icons.timer_rounded,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              AppSpacing.xl,
              Text('Recent Success Stories', style: AppTypography.h2),
              AppSpacing.md,
              _buildStoryCard(),
              AppSpacing.xl,
              Text('\uD83C\uDFC6 Top Rescuers', style: AppTypography.h2),
              AppSpacing.md,
              _buildLeaderboard(),
              AppSpacing.xxl,
              AppSpacing.xxl,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard() {
    return GlassSurface(
      blurSigma: 8,
      borderRadius: 18,
      elevation: 3,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.success.withValues(alpha: 0.15),
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: const Center(
              child: Text('\uD83D\uDC36', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Buddy found!', style: AppTypography.h3),
                const SizedBox(height: 4),
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
      _LeaderEntry(rank: 1, name: 'Emily R.', reunions: 47, badge: 'Diamond',
          medalColor: const Color(0xFFFFD700)),
      _LeaderEntry(rank: 2, name: 'Marcus T.', reunions: 32, badge: 'Platinum',
          medalColor: const Color(0xFFC0C0C0)),
      _LeaderEntry(rank: 3, name: 'Jordan L.', reunions: 28, badge: 'Gold',
          medalColor: const Color(0xFFCD7F32)),
    ];

    return Column(
      children: rescuers.map((r) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassSurface(
            blurSigma: 6,
            borderRadius: 16,
            elevation: 1,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.emoji_events_rounded, size: 24, color: r.medalColor),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.secondary.withValues(alpha: 0.08),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.person, color: AppColors.ink500),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                      Text('${r.reunions} reunions', style: AppTypography.caption),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: Text(
                    r.badge,
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

class _GlassStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _GlassStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      blurSigma: 8,
      borderRadius: 18,
      elevation: 3,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.15),
                  color.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTypography.displaySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: AppColors.ink500,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderEntry {
  final int rank;
  final String name;
  final int reunions;
  final String badge;
  final Color medalColor;

  const _LeaderEntry({
    required this.rank,
    required this.name,
    required this.reunions,
    required this.badge,
    required this.medalColor,
  });
}
