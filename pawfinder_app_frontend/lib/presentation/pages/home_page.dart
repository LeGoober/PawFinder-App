import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/alert_card.dart';
import '../widgets/info_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'PawFinder',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.ink900),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.ink900,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InfoBanner(
              message: '\u26A0\uFE0F 3 pets missing near you',
              type: InfoBannerType.warning,
            ),
            AppSpacing.md,
            _buildMapPlaceholder(),
            AppSpacing.lg,
            Padding(
              padding: AppSpacing.paddingHorizontalLg,
              child: Text(
                'Nearby Alerts',
                style: AppTypography.h2,
              ),
            ),
            AppSpacing.sm,
            const AlertCard(
              petName: 'Max',
              species: 'Dog',
              timeMissing: '2 hours ago',
              distance: '0.5 km away',
              description:
                  'Golden Retriever, friendly. Last seen near Oak Street park.',
              reward: 100,
            ),
            const AlertCard(
              petName: 'Luna',
              species: 'Cat',
              timeMissing: '30 min ago',
              distance: '1.2 km away',
              description:
                  'Tabby cat with white paws. Wearing a blue collar.',
            ),
            const AlertCard(
              petName: 'Rocky',
              species: 'Dog',
              timeMissing: '1 hour ago',
              distance: '0.8 km away',
              description:
                  'German Shepherd, very shy. Do not chase. Last seen near the library.',
              reward: 200,
            ),
            AppSpacing.xxl,
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: AppSpacing.fabSize,
        height: AppSpacing.fabSize,
        child: FloatingActionButton(
          onPressed: () => context.push('/create-alert'),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: const Icon(
            Icons.add,
            color: AppColors.background,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: AppSpacing.mapPlaceholderHeight,
      margin: AppSpacing.paddingHorizontalLg,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.ink100,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: AppSpacing.avatarSize,
            color: AppColors.ink300,
          ),
          AppSpacing.sm,
          Text(
            '\uD83D\uDCCD Map loading...',
            style: AppTypography.body.copyWith(
              color: AppColors.ink500,
            ),
          ),
        ],
      ),
    );
  }
}
