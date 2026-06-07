import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Leaderboard',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
      ),
      body: ListView.builder(
        padding: AppSpacing.paddingLg,
        itemCount: _entries.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                '\uD83C\uDFC6 Top Rescuers',
                style: AppTypography.h3,
              ),
            );
          }

          final entry = _entries[index - 1];
          return _buildLeaderboardEntry(entry);
        },
      ),
    );
  }

  Widget _buildLeaderboardEntry(_LeaderboardEntry entry) {
    final medalIcon = _getMedalIcon(entry.rank);
    final medalColor = _getMedalColor(entry.rank);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: entry.rank <= 3 ? medalColor.withValues(alpha: 0.3) : AppColors.ink100,
          ),
          boxShadow: entry.rank <= 3
              ? [
                  BoxShadow(
                    color: medalColor.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: entry.rank <= 3
                  ? Icon(medalIcon, size: 22, color: medalColor)
                  : Text(
                      '${entry.rank}',
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink300,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            AppSpacing.sm,
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: entry.rank <= 3
                    ? medalColor.withValues(alpha: 0.1)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Icon(
                Icons.person,
                size: 24,
                color: AppColors.ink500,
              ),
            ),
            AppSpacing.md,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink900,
                    ),
                  ),
                  Text(
                    '${entry.reunions} reunions',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getBadgeColor(entry.badgeLevel),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                entry.badgeLevel,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMedalIcon(int rank) {
    return Icons.emoji_events;
  }

  Color _getMedalColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppColors.ink300;
    }
  }

  Color _getBadgeColor(String level) {
    switch (level) {
      case 'Diamond':
        return const Color(0xFFE8F0FE);
      case 'Platinum':
        return const Color(0xFFE8E8F0);
      case 'Gold':
        return const Color(0xFFFFF8E1);
      default:
        return AppColors.surface;
    }
  }
}

class _LeaderboardEntry {
  final int rank;
  final String name;
  final int reunions;
  final String badgeLevel;

  const _LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.reunions,
    required this.badgeLevel,
  });
}

const List<_LeaderboardEntry> _entries = [
  _LeaderboardEntry(rank: 1, name: 'Emily R.', reunions: 47, badgeLevel: 'Diamond'),
  _LeaderboardEntry(rank: 2, name: 'Marcus T.', reunions: 32, badgeLevel: 'Platinum'),
  _LeaderboardEntry(rank: 3, name: 'Jordan L.', reunions: 28, badgeLevel: 'Gold'),
  _LeaderboardEntry(rank: 4, name: 'Sarah K.', reunions: 21, badgeLevel: 'Gold'),
  _LeaderboardEntry(rank: 5, name: 'David M.', reunions: 15, badgeLevel: 'Silver'),
];
