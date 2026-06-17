import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../domain/entities/user.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/empty_state.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/stat_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Profile',
          style: AppTypography.h2.copyWith(color: AppColors.ink900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.ink700),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const SkeletonListLoader(itemCount: 4);
          }

          if (state is AuthAuthenticated) {
            return _AuthenticatedProfile(
              user: state.user,
              onLogout: () {
                authCubit.logout();
                context.go('/');
              },
            );
          }

          if (state is AuthError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load profile',
                subtitle: state.message,
                actionText: 'Retry',
                onAction: () => authCubit.checkAuthStatus(),
              ),
            );
          }

          // AuthInitial — not logged in
          return _NotLoggedIn();
        },
      ),
    );
  }
}

class _AuthenticatedProfile extends StatelessWidget {
  final User user;
  final VoidCallback onLogout;

  const _AuthenticatedProfile({required this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: Column(
        children: [
          _UserInfoCard(user: user),
          AppSpacing.lg,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Rescuer Level',
                    value: '${user.rescuerBadgeLevel}',
                    icon: Icons.military_tech,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    title: 'Joined',
                    value: dateFormat.format(user.createdAt),
                    icon: Icons.calendar_today,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.xl,
          _SettingsList(),
          AppSpacing.xl,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              text: 'Logout',
              type: AppButtonType.danger,
              onPressed: onLogout,
            ),
          ),
          AppSpacing.xxl,
        ],
      ),
    );
  }
}

class _NotLoggedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text('Sign in to view your profile', style: AppTypography.h3),
          const SizedBox(height: 8),
          Text(
            'Create alerts, track your pets, and help reunite lost pets in your community.',
            style: AppTypography.body.copyWith(color: AppColors.ink500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Sign In / Register',
            onPressed: () => context.go('/login'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _UserInfoCard extends StatelessWidget {
  final User user;

  const _UserInfoCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final badge = _getBadge(user.rescuerBadgeLevel);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
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
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              if (user.verified)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName ?? 'Pet Lover',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 2),
                if (badge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: badge.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge.label,
                      style: AppTypography.caption.copyWith(
                        color: badge.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  'Member since ${DateFormat.yMMMM().format(user.createdAt)}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.ink500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.ink500),
            onPressed: () => _showComingSoon(context, 'Edit Profile'),
          ),
        ],
      ),
    );
  }

  _BadgeInfo? _getBadge(int level) {
    if (level >= 3) {
      return const _BadgeInfo('🏆 Verified Rescuer', AppColors.secondary);
    }
    if (level >= 2) {
      return const _BadgeInfo('⭐ Active Helper', AppColors.primary);
    }
    if (level >= 1) {
      return const _BadgeInfo('🐾 New Helper', AppColors.success);
    }
    return null;
  }
}

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$feature — coming soon'),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: const Duration(seconds: 2),
    ),
  );
}

class _SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _SettingsItemData(
        icon: Icons.pets_outlined,
        title: 'My Pets',
        subtitle: 'Add and manage your registered pets',
        onTap: () => context.go('/home'),
      ),
      _SettingsItemData(
        icon: Icons.person_outline,
        title: 'Account Settings',
        subtitle: 'Update profile, email, password',
        onTap: () => _showComingSoon(context, 'Account Settings'),
      ),
      _SettingsItemData(
        icon: Icons.notifications_outlined,
        title: 'Notification Preferences',
        subtitle: 'Manage alert notifications',
        onTap: () => _showComingSoon(context, 'Notification Preferences'),
      ),
      _SettingsItemData(
        icon: Icons.lock_outline,
        title: 'Privacy Controls',
        subtitle: 'Control your visibility and data',
        onTap: () => _showComingSoon(context, 'Privacy Controls'),
      ),
      _SettingsItemData(
        icon: Icons.help_outline,
        title: 'Help & Support',
        subtitle: 'FAQs, contact, report issues',
        onTap: () => _showComingSoon(context, 'Help & Support'),
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ink100),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              if (index > 0)
                const Divider(height: 1, indent: 56, color: AppColors.ink100),
              InkWell(
                onTap: item.onTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 22, color: AppColors.ink700),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink900,
                              ),
                            ),
                            if (item.subtitle != null)
                              Text(
                                item.subtitle!,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.ink500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.ink300),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SettingsItemData {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItemData({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}

class _BadgeInfo {
  final String label;
  final Color color;

  const _BadgeInfo(this.label, this.color);
}
