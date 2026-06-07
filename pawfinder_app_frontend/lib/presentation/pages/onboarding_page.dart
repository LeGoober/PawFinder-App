import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToHome() {
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            children: [
              const Spacer(),
              Expanded(
                flex: 4,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  children: const [
                    _OnboardingSlide(
                      icon: Icons.pets,
                      title: 'Help Find Missing Pets',
                      subtitle:
                          'When a pet goes missing, the community comes together. '
                          'Get instant alerts about lost pets in your area and help '
                          'reunite them with their families.',
                    ),
                    _OnboardingSlide(
                      icon: Icons.lock_outline,
                      title: 'Your Privacy Matters',
                      subtitle:
                          'Your phone number and email are always hidden. '
                          'All communication happens safely within the app. '
                          'Your personal information stays private.',
                    ),
                    _OnboardingSlide(
                      icon: Icons.volunteer_activism,
                      title: 'Ready to Help?',
                      subtitle:
                          'Join thousands of pet lovers making a difference. '
                          'Every sighting reported brings a family closer to '
                          'reunion. Together, we bring them home.',
                    ),
                  ],
                ),
              ),
              _buildPageIndicator(),
              AppSpacing.xl,
              if (_currentPage == 2)
                AppButton(
                  text: 'Get Started',
                  onPressed: _goToHome,
                )
              else
                TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    'Skip',
                    style: AppTypography.button.copyWith(
                      color: AppColors.ink500,
                    ),
                  ),
                ),
              AppSpacing.xl,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.ink100,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        );
      }),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontalXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          AppSpacing.xxl,
          Text(
            title,
            style: AppTypography.h1,
            textAlign: TextAlign.center,
          ),
          AppSpacing.lg,
          Text(
            subtitle,
            style: AppTypography.body.copyWith(
              color: AppColors.ink500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
