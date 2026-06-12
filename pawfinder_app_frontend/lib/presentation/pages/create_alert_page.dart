import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/filter_chip.dart';
import '../widgets/glass_surface.dart';
import '../widgets/info_banner.dart';
import '../widgets/textured_background.dart';

class CreateAlertPage extends StatefulWidget {
  const CreateAlertPage({super.key});

  @override
  State<CreateAlertPage> createState() => _CreateAlertPageState();
}

class _CreateAlertPageState extends State<CreateAlertPage> {
  int _currentStep = 0;
  int? _selectedChipIndex;

  final List<String> _steps = [
    'Select Pet',
    'Last Location',
    'Details',
    'Reward',
    'Review & Submit',
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.ink900),
            onPressed: () => context.pop(),
          ),
          title: Column(
            children: [
              Text(
                'Report Missing Pet',
                style: AppTypography.h3.copyWith(color: AppColors.ink900),
              ),
              AppSpacing.xs,
              Text(
                '${_currentStep + 1}/5',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _buildStepIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingLg,
                child: _buildStepContent(),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: AppSpacing.paddingHorizontalLg,
      child: SizedBox(
        height: 48,
        child: Row(
          children: List.generate(_steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              return Expanded(
                child: Container(
                  height: 2,
                  color: (index ~/ 2) < _currentStep
                      ? AppColors.primary
                      : AppColors.ink100,
                ),
              );
            }
            final stepIndex = index ~/ 2;
            final isCompleted = stepIndex < _currentStep;
            final isActive = stepIndex == _currentStep;
            return Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive || isCompleted
                    ? AppColors.primary
                    : AppColors.ink100,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.background,
                      )
                    : Text(
                        '${stepIndex + 1}',
                        style: AppTypography.caption.copyWith(
                          color: isActive
                              ? AppColors.background
                              : AppColors.ink500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStepSelectPet();
      case 1:
        return _buildStepLocation();
      case 2:
        return _buildStepDetails();
      case 3:
        return _buildStepReward();
      case 4:
        return _buildStepReview();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepSelectPet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Pet', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Choose a pet from your list, or add a new one.',
          style: AppTypography.bodySmall,
        ),
        AppSpacing.lg,
        _buildPetCard(
          emoji: '\uD83D\uDC15',
          name: 'Max',
          breed: 'Golden Retriever',
          color: Color(0xFFE8D5B7),
          isSelected: true,
        ),
        AppSpacing.md,
        _buildPetCard(
          emoji: '\uD83D\uDC08',
          name: 'Luna',
          breed: 'Tabby Cat',
          color: Color(0xFFD5D5E8),
          isSelected: false,
        ),
        AppSpacing.lg,
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.add,
            color: AppColors.primary,
          ),
          label: Text(
            'Add New Pet',
            style: AppTypography.button.copyWith(color: AppColors.primary),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(double.infinity, AppSpacing.buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            side: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPetCard({
    required String emoji,
    required String name,
    required String breed,
    required Color color,
    required bool isSelected,
  }) {
    return Container(
      padding: AppSpacing.paddingCard,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.ink100,
          width: isSelected ? 2 : 1,
        ),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          AppSpacing.lg,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.h3),
                Text(breed, style: AppTypography.bodySmall),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildStepLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Location', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Where was your pet last seen?',
          style: AppTypography.bodySmall,
        ),
        AppSpacing.lg,
        Container(
          height: 200,
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
                  Icons.location_on,
                  size: AppSpacing.avatarSize,
                  color: AppColors.danger,
                ),
                AppSpacing.sm,
                Text(
                  'Drop pin on map',
                  style: AppTypography.body.copyWith(
                    color: AppColors.ink500,
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.lg,
        AppTextField(
          label: 'Address or Landmark',
          hint: 'e.g., Oak Street Park, near the fountain',
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: AppColors.ink500,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Help finders identify your pet.',
          style: AppTypography.bodySmall,
        ),
        AppSpacing.lg,
        AppTextField(
          label: 'When did they go missing?',
          hint: 'e.g., Earlier today around 3 PM',
          prefixIcon: const Icon(
            Icons.access_time,
            color: AppColors.ink500,
            size: 20,
          ),
        ),
        AppSpacing.lg,
        AppTextField(
          label: 'Circumstances',
          hint: 'e.g., Slipped out the back gate during the storm',
          prefixIcon: const Icon(
            Icons.description_outlined,
            color: AppColors.ink500,
            size: 20,
          ),
          maxLines: 3,
        ),
        AppSpacing.lg,
        AppTextField(
          label: 'Temperament',
          hint: 'e.g., Friendly with strangers, may be scared',
          prefixIcon: const Icon(
            Icons.psychology_outlined,
            color: AppColors.ink500,
            size: 20,
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildStepReward() {
    final rewardAmounts = ['50', '100', '200', 'Custom'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reward', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Optional. Offering a reward can help motivate searchers.',
          style: AppTypography.bodySmall,
        ),
        AppSpacing.lg,
        Text('Suggested Amounts', style: AppTypography.label),
        AppSpacing.md,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(rewardAmounts.length, (index) {
            return FilterChipWidget(
              label: rewardAmounts[index] == 'Custom'
                  ? rewardAmounts[index]
                  : '\$${rewardAmounts[index]}',
              isSelected: _selectedChipIndex == index,
              onTap: () {
                setState(() => _selectedChipIndex = index);
              },
            );
          }),
        ),
        if (_selectedChipIndex == 3) ...[
          AppSpacing.lg,
          AppTextField(
            label: 'Custom Amount',
            hint: '\$0.00',
            prefixIcon: const Icon(
              Icons.attach_money,
              color: AppColors.ink500,
              size: 20,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
        AppSpacing.xl,
        InfoBanner(
          message:
              '\uD83D\uDCB0 Rewards are held in escrow and released when your pet is confirmed safe.',
          type: InfoBannerType.info,
        ),
      ],
    );
  }

  Widget _buildStepReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review & Submit', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Double-check everything before posting.',
          style: AppTypography.bodySmall,
        ),
        AppSpacing.lg,
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingCard,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.ink100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _reviewRow('Pet', 'Max \u2014 Golden Retriever'),
              const Divider(color: AppColors.ink100),
              _reviewRow('Location', 'Oak Street Park'),
              const Divider(color: AppColors.ink100),
              _reviewRow('When', 'Today, around 3 PM'),
              const Divider(color: AppColors.ink100),
              _reviewRow('Temperament', 'Friendly, may be scared'),
              const Divider(color: AppColors.ink100),
              _reviewRow('Reward', '\$100'),
            ],
          ),
        ),
        AppSpacing.lg,
        InfoBanner(
          message:
              '\uD83D\uDD12 Your phone and email will be hidden. Finders will contact you through the app.',
          type: InfoBannerType.info,
        ),
      ],
    );
  }

  Widget _reviewRow(String label, String value) {
    return Padding(
      padding: AppSpacing.paddingVerticalSm,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.ink500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final isLastStep = _currentStep == _steps.length - 1;

    return Container(
      padding: AppSpacing.paddingLg.copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.paper.withValues(alpha: 0.4),
            AppColors.paper.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: AppButton(
                text: 'Back',
                type: AppButtonType.secondary,
                onPressed: _previousStep,
              ),
            ),
          if (_currentStep > 0) AppSpacing.lg,
          Expanded(
            child: AppButton(
              text: isLastStep ? 'Submit Alert' : 'Continue',
              onPressed: _nextStep,
            ),
          ),
        ],
      ),
    );
  }
}
