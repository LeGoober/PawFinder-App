import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'glass_surface.dart';
import 'status_badge.dart';

class AlertCard extends StatelessWidget {
  final String petName;
  final String species;
  final String timeMissing;
  final String distance;
  final String? description;
  final double? reward;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onActionTap;

  const AlertCard({
    super.key,
    required this.petName,
    required this.species,
    required this.timeMissing,
    required this.distance,
    this.description,
    this.reward,
    this.imageUrl,
    this.onTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GlassSurface(
        blurSigma: 10,
        borderRadius: 20,
        elevation: 3,
        // Warmer, more opaque glass for text readability
        customGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xCCFFFBF5), // 80% opacity warm paper
            Color(0xC2FFF5EB), // 76% card tone
            Color(0xB8FFF0E3), // 72% warm overlay
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            splashColor: AppColors.primary.withValues(alpha: 0.06),
            highlightColor: AppColors.primary.withValues(alpha: 0.03),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPetSilhouette(),
                  const SizedBox(width: 14),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPetSilhouette() {
    final isDog = species == 'Dog';
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.10),
            AppColors.secondary.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
          color: isDog
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.secondary.withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Icon(
          isDog ? Icons.pets : Icons.pets,
          size: 28,
          color: isDog
              ? AppColors.primary.withValues(alpha: 0.6)
              : AppColors.secondary.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status row
        Row(
          children: [
            StatusBadge(text: 'MISSING', type: StatusType.active),
            const SizedBox(width: 8),
            // Time pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.ink900.withValues(alpha: 0.04),
              ),
              child: Text(
                timeMissing,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink700,
                ),
              ),
            ),
            if (reward != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.reward.withValues(alpha: 0.2),
                      AppColors.reward.withValues(alpha: 0.08),
                    ],
                  ),
                ),
                child: Text(
                  '\$${reward!.toStringAsFixed(0)}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.reward,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Pet name — larger, bolder
        Text(
          petName,
          style: AppTypography.h3.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        // Species + breed
        Text(
          species,
          style: AppTypography.body.copyWith(
            color: AppColors.ink500,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            description!,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.ink700,
              height: 1.45,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 12),
        // Bottom row — location + action (reward moved to status row)
        Row(
          children: [
            // Location
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.secondary.withValues(alpha: 0.08),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded,
                      size: 13, color: AppColors.secondary),
                  const SizedBox(width: 3),
                  Text(
                    distance,
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // CTA icon button — compact, no overflow
            GestureDetector(
              onTap: onActionTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.08),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.visibility_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
