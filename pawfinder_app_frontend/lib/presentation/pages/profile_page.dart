import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildUserInfoCard(),
            AppSpacing.lg,
            _buildSettingsList(),
            AppSpacing.xl,
            Padding(
              padding: AppSpacing.paddingHorizontalLg,
              child: AppButton(
                text: 'Logout',
                type: AppButtonType.danger,
                onPressed: () {},
              ),
            ),
            AppSpacing.xxxl,
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      margin: AppSpacing.paddingLg,
      padding: AppSpacing.paddingXl,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.ink100),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink900.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.avatarSizeLarge,
            height: AppSpacing.avatarSizeLarge,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius:
                  BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.person,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.lg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alex Johnson', style: AppTypography.h2),
                AppSpacing.xs,
                Text(
                  'alex.johnson@email.com',
                  style: AppTypography.bodySmall,
                ),
                AppSpacing.xs,
                Text(
                  '\uD83D\uDC36 2 pets registered',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.edit_outlined,
            color: AppColors.ink500,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    final items = [
      _SettingsItem(
        icon: Icons.pets_outlined,
        title: 'My Pets',
        onTap: () {},
      ),
      _SettingsItem(
        icon: Icons.settings_outlined,
        title: 'Account Settings',
        onTap: () {},
      ),
      _SettingsItem(
        icon: Icons.notifications_outlined,
        title: 'Notification Preferences',
        onTap: () {},
      ),
      _SettingsItem(
        icon: Icons.lock_outline,
        title: 'Privacy Controls',
        onTap: () {},
      ),
      _SettingsItem(
        icon: Icons.help_outline,
        title: 'Help & Support',
        onTap: () {},
      ),
    ];

    return Container(
      margin: AppSpacing.paddingHorizontalLg,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.ink100),
      ),
      child: Column(
        children: items.map((item) {
          return InkWell(
            onTap: item.onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: AppSpacing.iconMedium,
                    color: AppColors.ink700,
                  ),
                  AppSpacing.md,
                  Expanded(
                    child: Text(
                      item.title,
                      style: AppTypography.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink900,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.ink300,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
