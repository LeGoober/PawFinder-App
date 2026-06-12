import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/alert_card.dart';
import '../widgets/info_banner.dart';
import '../widgets/glass_surface.dart';
import '../widgets/textured_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return TexturedBackground(
      mode: BackgroundMode.warmGlass,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: _buildGlassAppBar(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Warning banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InfoBanner(
                  message: '\u26A0\uFE0F 3 pets missing near you',
                  type: InfoBannerType.warning,
                ),
              ),
              AppSpacing.md,
              // Map area — glass panel with blurred map hint
              _buildGlassMapArea(),
              AppSpacing.lg,
              // Section header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      'Nearby Alerts',
                      style: AppTypography.h2,
                    ),
                    const Spacer(),
                    Text(
                      'See all',
                      style: AppTypography.label.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.sm,
              // Alert cards in glass
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
              AppSpacing.xxl,
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 64,
          height: 64,
          child: FloatingActionButton.extended(
            onPressed: () => context.push('/create-alert'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            icon: const Icon(Icons.pets, size: 22),
            label: Text(
              'Report',
              style: AppTypography.button.copyWith(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildGlassAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Text(
        'PawFinder',
        style: AppTypography.h2.copyWith(color: AppColors.ink900),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: AppColors.ink900),
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
    );
  }

  Widget _buildGlassMapArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassSurface(
        borderRadius: 24,
        blurSigma: 6,
        elevation: 4,
        height: 220,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Map icon in frosted glass style
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.secondary.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.map_outlined,
                size: 30,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Interactive Map Coming Soon',
              style: AppTypography.h3.copyWith(
                color: AppColors.ink900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to view lost pets near your location',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
