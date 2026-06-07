import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/info_banner.dart';

class AlertDetailPage extends StatelessWidget {
  const AlertDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
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
                    padding: AppSpacing.paddingHorizontalLg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InfoBanner(
                          message:
                              '\uD83D\uDD12 Your contact info is hidden from finders.',
                          type: InfoBannerType.info,
                        ),
                        AppSpacing.lg,
                        Text('Max', style: AppTypography.h1),
                        AppSpacing.xs,
                        Row(
                          children: [
                            Text(
                              'Golden Retriever',
                              style: AppTypography.bodyLarge,
                            ),
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
                              'Missing 2 hours',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                        AppSpacing.xl,
                        Text('Description', style: AppTypography.h3),
                        AppSpacing.sm,
                        Text(
                          'Max is a friendly 3-year-old Golden Retriever with a red '
                          'collar and ID tag. He slipped out the back gate during the '
                          'afternoon thunderstorm. He responds to his name and loves '
                          'treats. Please do not chase him \u2014 he may get scared and '
                          'run further.',
                          style: AppTypography.body.copyWith(
                            color: AppColors.ink700,
                          ),
                        ),
                        AppSpacing.xl,
                        InfoBanner(
                          message:
                              '\u26A0\uFE0F Never send money upfront. Rewards are '
                              'handled securely in-app.',
                          type: InfoBannerType.warning,
                        ),
                        AppSpacing.lg,
                        _buildRewardCard(),
                        AppSpacing.xl,
                        Text('Recent Sightings', style: AppTypography.h3),
                        AppSpacing.md,
                        _buildSightingItem(
                          location: 'Oak Street Park',
                          time: '15 min ago',
                          reporter: 'Sarah M.',
                        ),
                        AppSpacing.sm,
                        _buildSightingItem(
                          location: 'Near the library',
                          time: '1 hour ago',
                          reporter: 'James K.',
                        ),
                        AppSpacing.xxxl,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: AppSpacing.heroImageHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
      ),
      child: Center(
        child: Text(
          '\uD83D\uDC15',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontalLg.copyWith(top: 8),
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
              padding: EdgeInsets.zero,
              color: AppColors.ink900,
            ),
          ),
          const Spacer(),
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            onSelected: (value) {},
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share_outlined,
                        size: 20, color: AppColors.ink700),
                    AppSpacing.sm,
                    Text('Share', style: AppTypography.body),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'save',
                child: Row(
                  children: [
                    const Icon(Icons.bookmark_outline,
                        size: 20, color: AppColors.ink700),
                    AppSpacing.sm,
                    Text('Save', style: AppTypography.body),
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
              child: const Icon(
                Icons.more_horiz,
                size: 20,
                color: AppColors.ink900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.rewardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.reward.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.reward,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: AppColors.rewardDark,
            ),
          ),
          AppSpacing.lg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$100 Reward',
                  style: AppTypography.h3.copyWith(
                    color: AppColors.rewardDark,
                  ),
                ),
                Text(
                  'Offered for safe return. Held securely in escrow.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.rewardDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSightingItem({
    required String location,
    required String time,
    required String reporter,
  }) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.ink100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(
              Icons.visibility,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          AppSpacing.md,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$time \u2022 Reported by $reporter',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: AppSpacing.paddingLg,
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
          text: '\uD83D\uDCF8 I Saw This Pet',
          type: AppButtonType.success,
          onPressed: () {},
        ),
      ),
    );
  }
}
