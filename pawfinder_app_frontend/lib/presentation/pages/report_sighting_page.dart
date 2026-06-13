import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../blocs/sighting/sighting_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/info_banner.dart';

class ReportSightingPage extends StatefulWidget {
  final String? alertId;
  final String? finderId;

  const ReportSightingPage({super.key, this.alertId, this.finderId});

  @override
  State<ReportSightingPage> createState() => _ReportSightingPageState();
}

class _ReportSightingPageState extends State<ReportSightingPage> {
  late final SightingCubit _cubit;
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _cubit = SightingCubit(sightingRepository: getIt());
  }

  @override
  void dispose() {
    _cubit.close();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Placeholder coordinates — in production use LocationService
    _cubit.reportSighting(
      alertId: widget.alertId ?? '',
      finderId: widget.finderId ?? '',
      lat: -26.2041,
      lng: 28.0473,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.ink900),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Report Sighting',
            style: AppTypography.h2.copyWith(color: AppColors.ink900),
          ),
        ),
        body: BlocConsumer<SightingCubit, SightingState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is SightingReported) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sighting reported! The owner will be notified.'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.pop();
            }
            if (state is SightingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.danger,
                ),
              );
            }
          },
          builder: (context, state) {
            if (_submitted && state is SightingLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Submitting sighting report...'),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoBanner(
                      message:
                          '🔒 Your identity is hidden. Only the pet owner will see this report.',
                      type: InfoBannerType.info,
                    ),
                    AppSpacing.lg,
                    Text('Location', style: AppTypography.h3),
                    AppSpacing.sm,
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.ink100),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 40,
                              color: AppColors.danger.withValues(alpha: 0.7),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '📍 Current location will be attached',
                              style: AppTypography.body.copyWith(
                                color: AppColors.ink500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.lg,
                    Text('Photo (Optional)', style: AppTypography.h3),
                    AppSpacing.sm,
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.border,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.surface,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt_outlined,
                                  size: 32, color: AppColors.ink500),
                              const SizedBox(height: 4),
                              const Text('Tap to add photo',
                                  style: TextStyle(color: AppColors.ink500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AppSpacing.lg,
                    AppTextField(
                      label: 'Notes for the owner',
                      hint: 'Describe where and when you saw the pet, its condition, etc.',
                      controller: _notesController,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please add some notes about the sighting';
                        }
                        return null;
                      },
                    ),
                    AppSpacing.xl,
                    AppButton(
                      text: '📸 Submit Sighting Report',
                      onPressed: state is SightingLoading ? null : _submit,
                    ),
                    AppSpacing.xxl,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
