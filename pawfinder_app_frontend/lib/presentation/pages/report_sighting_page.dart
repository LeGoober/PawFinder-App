import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../../services/location_service.dart';
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
  final _imagePicker = ImagePicker();

  bool _submitted = false;
  bool _locating = false;
  double? _lat;
  double? _lng;
  String? _locationLabel;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _cubit = SightingCubit(sightingRepository: getIt());
    _captureLocation();
  }

  @override
  void dispose() {
    _cubit.close();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _captureLocation() async {
    setState(() => _locating = true);
    try {
      final locationService = getIt<LocationService>();
      final pos = await locationService.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _locationLabel =
            '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}';
        _locating = false;
      });
    } catch (_) {
      setState(() {
        _locationLabel = '📍 Could not get location — using approximate';
        _lat = -26.2041;
        _lng = 28.0473;
        _locating = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final xfile =
          await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (xfile != null) {
        setState(() => _photoPath = xfile.path);
      }
    } catch (_) {
      // Permission denied or cancelled
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    _cubit.reportSighting(
      alertId: widget.alertId ?? '',
      finderId: widget.finderId ?? '',
      lat: _lat ?? -26.2041,
      lng: _lng ?? 28.0473,
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
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.ink100),
                      ),
                      child: _locating
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                      color: AppColors.primary),
                                  SizedBox(height: 12),
                                  Text('Getting your location...'),
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.12),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.danger,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Location',
                                        style: AppTypography.label
                                            .copyWith(
                                          color: AppColors.ink500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _locationLabel ??
                                            'Locating...',
                                        style: AppTypography.body
                                            .copyWith(
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: _captureLocation,
                                  icon: const Icon(Icons.refresh,
                                      size: 16),
                                  label: const Text('Retry'),
                                ),
                              ],
                            ),
                    ),
                    AppSpacing.lg,
                    Text('Photo (Optional)', style: AppTypography.h3),
                    AppSpacing.sm,
                    InkWell(
                      onTap: _pickImage,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: _photoPath != null ? 200 : 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.ink100,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.surface,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _photoPath != null
                            ? Image.file(
                                File(_photoPath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 32,
                                      color: AppColors.ink500,
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Tap to add photo',
                                      style: TextStyle(
                                        color: AppColors.ink500,
                                      ),
                                    ),
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
