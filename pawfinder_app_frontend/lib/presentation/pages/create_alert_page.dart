import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/alert_repository.dart';
import '../../domain/repositories/pet_repository.dart';
import '../../services/location_service.dart';
import '../blocs/alert/alert_cubit.dart';
import '../blocs/pet/pet_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/filter_chip.dart';
import '../widgets/glass_surface.dart';
import '../widgets/info_banner.dart';
import '../widgets/textured_background.dart';

// ─────────────────────────────────────────────────────────────
// Page entry-point — provides cubits via MultiBlocProvider
// ─────────────────────────────────────────────────────────────

class CreateAlertPage extends StatelessWidget {
  const CreateAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PetCubit(
            petRepository: getIt<PetRepository>(),
            alertRepository: getIt<AlertRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => AlertCubit(
            alertRepository: getIt<AlertRepository>(),
            locationService: getIt<LocationService>(),
          ),
        ),
      ],
      child: const _CreateAlertWizard(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Wizard state machine
// ─────────────────────────────────────────────────────────────

class _CreateAlertWizard extends StatefulWidget {
  const _CreateAlertWizard();

  @override
  State<_CreateAlertWizard> createState() => _CreateAlertWizardState();
}

class _CreateAlertWizardState extends State<_CreateAlertWizard> {
  // ── Wizard progress ────────────────────────────────────────
  int _currentStep = 0;
  static const _stepLabels = [
    'Select Pet',
    'Last Location',
    'Details',
    'Reward',
    'Review & Submit',
  ];

  // ── Step 0 — Select Pet ────────────────────────────────────
  Pet? _selectedPet;
  bool _showAddPetForm = false;

  // ── Step 1 — Location ──────────────────────────────────────
  double? _lat;
  double? _lng;
  bool _isLocating = false;
  String? _locationError;
  final _addressController = TextEditingController();

  // ── Step 2 — Details ───────────────────────────────────────
  final _lastSeenController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _temperamentController = TextEditingController();

  // ── Step 3 — Reward ────────────────────────────────────────
  int? _selectedRewardChip; // index into _rewardPresets
  final _customRewardController = TextEditingController();
  static const _rewardPresets = [50, 100, 200, 500];
  double _geofenceRadiusKm = 2.0;
  static const _geofenceOptions = [1.0, 2.0, 5.0, 10.0];

  // ── Add-Pet inline form ────────────────────────────────────
  final _addPetFormKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _petSpeciesController = TextEditingController();
  final _petBreedController = TextEditingController();
  final _petColorController = TextEditingController();
  String? _petSize;

  // ── Lifecycle ──────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetCubit>().loadPets();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _lastSeenController.dispose();
    _descriptionController.dispose();
    _temperamentController.dispose();
    _customRewardController.dispose();
    _petNameController.dispose();
    _petSpeciesController.dispose();
    _petBreedController.dispose();
    _petColorController.dispose();
    super.dispose();
  }

  // ── Derived values ─────────────────────────────────────────

  double get _rewardAmount {
    if (_selectedRewardChip != null &&
        _selectedRewardChip! < _rewardPresets.length) {
      return _rewardPresets[_selectedRewardChip!].toDouble();
    }
    return double.tryParse(_customRewardController.text.replaceAll(',', '.')) ??
        0.0;
  }

  String get _rewardLabel =>
      _rewardAmount > 0 ? 'R ${_rewardAmount.toStringAsFixed(0)}' : 'None';

  /// Combine last-seen, circumstances, and temperament into one
  /// block of text submitted as the alert description.
  String get _buildDescription {
    final buf = StringBuffer();
    if (_lastSeenController.text.trim().isNotEmpty) {
      buf.writeln('Last seen: ${_lastSeenController.text.trim()}');
    }
    if (_descriptionController.text.trim().isNotEmpty) {
      buf.writeln(_descriptionController.text.trim());
    }
    if (_temperamentController.text.trim().isNotEmpty) {
      buf.writeln('Temperament: ${_temperamentController.text.trim()}');
    }
    return buf.toString().trim();
  }

  /// Whether the user has filled enough to advance from the current step.
  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedPet != null;
      case 1:
        return (_lat != null && _lng != null) ||
            _addressController.text.trim().isNotEmpty;
      case 2:
        return _descriptionController.text.trim().isNotEmpty;
      case 3:
        return true; // reward is optional
      case 4:
        return true;
      default:
        return false;
    }
  }

  // ── Navigation helpers ─────────────────────────────────────

  void _nextStep() {
    if (_currentStep < _stepLabels.length - 1) {
      setState(() => _currentStep++);
      _onStepEnter(_currentStep);
      // Scroll to top on step change
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Scrollable.ensureVisible(context, alignment: 0),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _onStepEnter(int step) {
    if (step == 1) _detectLocation();
  }

  // ── Location detection ─────────────────────────────────────

  Future<void> _detectLocation() async {
    if (_lat != null && _lng != null) return; // already captured
    setState(() {
      _isLocating = true;
      _locationError = null;
    });
    try {
      final ls = getIt<LocationService>();
      final pos = await ls.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _isLocating = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLocating = false;
        _locationError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ── Submit ─────────────────────────────────────────────────

  void _submitAlert() {
    final alertCubit = context.read<AlertCubit>();
    alertCubit.createAlert(
      petId: _selectedPet!.id,
      lat: _lat ?? 0,
      lng: _lng ?? 0,
      lastSeenAddress: _addressController.text.trim(),
      description: _buildDescription,
      rewardAmount: _rewardAmount,
      rewardCurrency: 'ZAR',
      geofenceRadiusKm: _geofenceRadiusKm,
    );
  }

  // ── Pet cubit listener ─────────────────────────────────────

  void _onPetStateChanged(BuildContext context, PetState state) {
    if (state is PetCreated) {
      // Reload list so the new pet appears
      context.read<PetCubit>().loadPets();
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Pet added — select it above to continue.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {
        _showAddPetForm = false;
        _petNameController.clear();
        _petSpeciesController.clear();
        _petBreedController.clear();
        _petColorController.clear();
        _petSize = null;
      });
    } else if (state is PetError) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Alert cubit listener ───────────────────────────────────

  void _onAlertStateChanged(BuildContext context, AlertState state) {
    if (state is AlertCreated) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🚀 Alert posted! Your community has been notified.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } else if (state is AlertError) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PetCubit, PetState>(listener: _onPetStateChanged),
        BlocListener<AlertCubit, AlertState>(listener: _onAlertStateChanged),
      ],
      child: TexturedBackground(
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
                  '${_currentStep + 1}/${_stepLabels.length}',
                  style:
                      AppTypography.caption.copyWith(color: AppColors.primary),
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
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Step indicator ─────────────────────────────────────────

  Widget _buildStepIndicator() {
    return Padding(
      padding: AppSpacing.paddingHorizontalLg,
      child: SizedBox(
        height: 48,
        child: Row(
          children: List.generate(_stepLabels.length * 2 - 1, (index) {
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
                color:
                    isActive || isCompleted ? AppColors.primary : AppColors.ink100,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check,
                        size: 16, color: AppColors.background)
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

  // ────────────────────────────────────────────────────────────
  // Step 0 — Select Pet
  // ────────────────────────────────────────────────────────────

  Widget _buildStepSelectPet() {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, petState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Pet', style: AppTypography.h2),
            AppSpacing.xs,
            Text(
              'Choose a pet from your list, or add a new one.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.ink500,
              ),
            ),
            AppSpacing.lg,

            // ── Loading state ──────────────────────────────
            if (petState is PetLoading && !_showAddPetForm) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ],

            // ── Pet list ───────────────────────────────────
            if (petState is PetsLoaded) ...[
              if (petState.pets.isEmpty && !_showAddPetForm)
                _buildNoPetsYet()
              else ...[
                ...petState.pets.map(
                  (pet) => Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.md.height!),
                    child: _buildPetCard(pet),
                  ),
                ),
                if (!_showAddPetForm) ...[
                  AppSpacing.lg,
                  _buildAddPetButton(),
                ],
              ],
            ],

            // ── Error state ────────────────────────────────
            if (petState is PetError && !_showAddPetForm) ...[
              InfoBanner(
                message: petState.message,
                type: InfoBannerType.error,
              ),
              AppSpacing.md,
              _buildAddPetButton(),
            ],

            // ── Initial / fallback ─────────────────────────
            if (petState is PetInitial && !_showAddPetForm)
              _buildAddPetButton(),

            // ── Add-Pet inline form ────────────────────────
            if (_showAddPetForm) ...[
              AppSpacing.md,
              _buildAddPetForm(petState),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNoPetsYet() {
    return GlassSurface(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.pets_outlined,
                size: 48, color: AppColors.ink300),
            AppSpacing.md,
            Text(
              'No pets registered yet',
              style: AppTypography.h3.copyWith(color: AppColors.ink700),
            ),
            AppSpacing.sm,
            Text(
              'Add your first pet to create an alert.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.ink500,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.lg,
            _buildAddPetButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPetButton() {
    return OutlinedButton.icon(
      onPressed: () => setState(() => _showAddPetForm = true),
      icon: const Icon(Icons.add, color: AppColors.primary),
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
    );
  }

  Widget _buildPetCard(Pet pet) {
    final isSelected = _selectedPet?.id == pet.id;
    final avatarColor = _petSpeciesColor(pet.species);
    final emoji = _petSpeciesEmoji(pet.species);

    return GestureDetector(
      onTap: _showAddPetForm
          ? null
          : () => setState(() {
                _selectedPet = isSelected ? null : pet;
              }),
      child: Container(
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
            // Pet avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: avatarColor,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Center(
                child: Text(emoji,
                    style: const TextStyle(fontSize: 28, height: 1)),
              ),
            ),
            AppSpacing.lg,
            // Pet info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: AppTypography.h3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    [pet.breed, pet.color, pet.size]
                        .where((e) => e != null && e.isNotEmpty)
                        .join(' · '),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.ink500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Selection indicator
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.ink300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPetForm(PetState petState) {
    final isLoading = petState is PetLoading;

    return GlassSurface(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _addPetFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text('New Pet', style: AppTypography.h3),
                const Spacer(),
                IconButton(
                  onPressed: isLoading
                      ? null
                      : () => setState(() => _showAddPetForm = false),
                  icon: const Icon(Icons.close,
                      size: 20, color: AppColors.ink500),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            AppSpacing.md,

            // Name (required)
            AppTextField(
              label: 'Name *',
              hint: 'e.g., Buddy',
              controller: _petNameController,
              prefixIcon: const Icon(Icons.badge_outlined,
                  color: AppColors.ink500, size: 20),
            ),
            AppSpacing.md,

            // Species (required) — chip toggle
            Text('Species *', style: AppTypography.label),
            AppSpacing.sm,
            Row(
              children: [
                FilterChipWidget(
                  label: '🐕 Dog',
                  isSelected: _petSpeciesController.text.toLowerCase() == 'dog',
                  onTap: () => setState(
                    () => _petSpeciesController.text =
                        _petSpeciesController.text.toLowerCase() == 'dog'
                            ? ''
                            : 'Dog',
                  ),
                ),
                const SizedBox(width: 8),
                FilterChipWidget(
                  label: '🐈 Cat',
                  isSelected: _petSpeciesController.text.toLowerCase() == 'cat',
                  onTap: () => setState(
                    () => _petSpeciesController.text =
                        _petSpeciesController.text.toLowerCase() == 'cat'
                            ? ''
                            : 'Cat',
                  ),
                ),
              ],
            ),
            AppSpacing.md,

            // Breed
            AppTextField(
              label: 'Breed',
              hint: 'e.g., Golden Retriever',
              controller: _petBreedController,
              prefixIcon: const Icon(Icons.category_outlined,
                  color: AppColors.ink500, size: 20),
            ),
            AppSpacing.md,

            // Color
            AppTextField(
              label: 'Color',
              hint: 'e.g., Golden, White & Brown',
              controller: _petColorController,
              prefixIcon: const Icon(Icons.palette_outlined,
                  color: AppColors.ink500, size: 20),
            ),
            AppSpacing.md,

            // Size — chip toggle
            Text('Size', style: AppTypography.label),
            AppSpacing.sm,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Small', 'Medium', 'Large'].map((size) {
                return FilterChipWidget(
                  label: size,
                  isSelected: _petSize == size,
                  onTap: () => setState(
                    () => _petSize = _petSize == size ? null : size,
                  ),
                );
              }).toList(),
            ),
            AppSpacing.lg,

            // Save button
            AppButton(
              text: 'Save Pet',
              isLoading: isLoading,
              onPressed: isLoading ? null : _submitNewPet,
            ),
          ],
        ),
      ),
    );
  }

  void _submitNewPet() {
    if (_petNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet name is required.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_petSpeciesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Species is required.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    context.read<PetCubit>().createPet(
          name: _petNameController.text.trim(),
          species: _petSpeciesController.text.trim(),
          breed: _petBreedController.text.trim().isEmpty
              ? null
              : _petBreedController.text.trim(),
          color: _petColorController.text.trim().isEmpty
              ? null
              : _petColorController.text.trim(),
          size: _petSize,
        );
  }

  Color _petSpeciesColor(String species) {
    final s = species.toLowerCase();
    if (s == 'cat') return const Color(0xFFD5D5E8);
    if (s == 'dog') return const Color(0xFFE8D5B7);
    return const Color(0xFFD5E8D5);
  }

  String _petSpeciesEmoji(String species) {
    final s = species.toLowerCase();
    if (s == 'cat') return '🐈';
    if (s == 'dog') return '🐕';
    return '🐾';
  }

  // ────────────────────────────────────────────────────────────
  // Step 1 — Last Location
  // ────────────────────────────────────────────────────────────

  Widget _buildStepLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Location', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'We\'ll use your current GPS to help searchers find your pet.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.ink500),
        ),
        AppSpacing.lg,

        // GPS status tile
        _buildGpsStatusTile(),
        AppSpacing.lg,

        // Address / landmark
        AppTextField(
          label: 'Address or Landmark',
          hint: 'e.g., Oak Street Park, near the fountain',
          prefixIcon: const Icon(Icons.location_on_outlined,
              color: AppColors.ink500, size: 20),
          controller: _addressController,
        ),
      ],
    );
  }

  Widget _buildGpsStatusTile() {
    return GlassSurface(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _lat != null
                  ? AppColors.success.withValues(alpha: 0.12)
                  : _isLocating
                      ? AppColors.reward.withValues(alpha: 0.12)
                      : AppColors.danger.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _isLocating
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.reward,
                    ),
                  )
                : Icon(
                    _lat != null ? Icons.my_location : Icons.location_off,
                    color: _lat != null
                        ? AppColors.success
                        : AppColors.danger,
                    size: 22,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _lat != null
                      ? '📍 GPS captured'
                      : _isLocating
                          ? 'Detecting your location…'
                          : 'GPS unavailable',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink900,
                  ),
                ),
                const SizedBox(height: 2),
                if (_lat != null)
                  Text(
                    '${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.ink500),
                  )
                else if (_locationError != null)
                  Text(
                    _locationError!,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.danger),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                else if (!_isLocating)
                  Text(
                    'Enter an address below instead.',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.ink500),
                  ),
              ],
            ),
          ),
          if (_lat == null && !_isLocating)
            TextButton(
              onPressed: _detectLocation,
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Step 2 — Details
  // ────────────────────────────────────────────────────────────

  Widget _buildStepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Details', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Help finders identify your pet.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.ink500),
        ),
        AppSpacing.lg,
        AppTextField(
          label: 'When did they go missing?',
          hint: 'e.g., Earlier today around 3 PM',
          prefixIcon: const Icon(Icons.access_time,
              color: AppColors.ink500, size: 20),
          controller: _lastSeenController,
        ),
        AppSpacing.lg,
        AppTextField(
          label: 'Circumstances *',
          hint: 'e.g., Slipped out the back gate during the storm',
          prefixIcon: const Icon(Icons.description_outlined,
              color: AppColors.ink500, size: 20),
          controller: _descriptionController,
          maxLines: 3,
        ),
        AppSpacing.lg,
        AppTextField(
          label: 'Temperament',
          hint: 'e.g., Friendly with strangers, may be scared',
          prefixIcon: const Icon(Icons.psychology_outlined,
              color: AppColors.ink500, size: 20),
          controller: _temperamentController,
          maxLines: 2,
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Step 3 — Reward
  // ────────────────────────────────────────────────────────────

  Widget _buildStepReward() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reward', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Optional. Offering a reward can help motivate searchers.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.ink500),
        ),
        AppSpacing.lg,

        // Suggested amounts
        Text('Suggested Amounts', style: AppTypography.label),
        AppSpacing.md,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...List.generate(_rewardPresets.length, (index) {
              return FilterChipWidget(
                label: 'R ${_rewardPresets[index]}',
                isSelected: _selectedRewardChip == index,
                onTap: () => setState(() {
                  _selectedRewardChip =
                      _selectedRewardChip == index ? null : index;
                  _customRewardController.clear();
                }),
              );
            }),
            FilterChipWidget(
              label: 'Custom',
              isSelected: _selectedRewardChip == null &&
                  _customRewardController.text.isNotEmpty,
              onTap: () => setState(() => _selectedRewardChip = null),
            ),
          ],
        ),

        // Custom amount
        if (_selectedRewardChip == null) ...[
          AppSpacing.lg,
          AppTextField(
            label: 'Custom Amount (ZAR)',
            hint: '0.00',
            prefixIcon: const Icon(Icons.attach_money,
                color: AppColors.ink500, size: 20),
            controller: _customRewardController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ],

        // Geofence radius
        AppSpacing.xl,
        Text('Search Radius', style: AppTypography.label),
        AppSpacing.sm,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _geofenceOptions.map((km) {
            return FilterChipWidget(
              label: '${km.toStringAsFixed(0)} km',
              isSelected: _geofenceRadiusKm == km,
              onTap: () => setState(() => _geofenceRadiusKm = km),
            );
          }).toList(),
        ),

        AppSpacing.xl,
        InfoBanner(
          message:
              '💰 Rewards are held in escrow and released when your pet is confirmed safe.',
          type: InfoBannerType.info,
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Step 4 — Review & Submit
  // ────────────────────────────────────────────────────────────

  Widget _buildStepReview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review & Submit', style: AppTypography.h2),
        AppSpacing.xs,
        Text(
          'Double-check everything before posting.',
          style: AppTypography.bodySmall.copyWith(color: AppColors.ink500),
        ),
        AppSpacing.lg,

        // Summary card
        BlocBuilder<AlertCubit, AlertState>(
          builder: (context, alertState) {
            final isSubmitting = alertState is AlertLoading;

            return Container(
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
                  _reviewRow(
                    'Pet',
                    '${_selectedPet?.name ?? '—'}  ·  ${_selectedPet?.species ?? ''}',
                  ),
                  const Divider(color: AppColors.ink100),
                  _reviewRow(
                    'Breed',
                    _selectedPet?.breed ?? '—',
                  ),
                  const Divider(color: AppColors.ink100),
                  _reviewRow(
                    'Location',
                    _lat != null
                        ? '${_lat!.toStringAsFixed(4)}, ${_lng!.toStringAsFixed(4)}'
                        : _addressController.text.isNotEmpty
                            ? _addressController.text
                            : '—',
                  ),
                  if (_addressController.text.isNotEmpty) ...[
                    const Divider(color: AppColors.ink100),
                    _reviewRow(
                      'Address',
                      _addressController.text,
                    ),
                  ],
                  const Divider(color: AppColors.ink100),
                  _reviewRow(
                    'Last Seen',
                    _lastSeenController.text.isNotEmpty
                        ? _lastSeenController.text
                        : '—',
                  ),
                  const Divider(color: AppColors.ink100),
                  _reviewRow(
                    'Circumstances',
                    _descriptionController.text.isNotEmpty
                        ? _descriptionController.text
                        : '—',
                  ),
                  if (_temperamentController.text.isNotEmpty) ...[
                    const Divider(color: AppColors.ink100),
                    _reviewRow(
                      'Temperament',
                      _temperamentController.text,
                    ),
                  ],
                  const Divider(color: AppColors.ink100),
                  _reviewRow('Reward', _rewardLabel),
                  const Divider(color: AppColors.ink100),
                  _reviewRow(
                    'Search Radius',
                    '${_geofenceRadiusKm.toStringAsFixed(0)} km',
                  ),

                  if (isSubmitting) ...[
                    AppSpacing.lg,
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        AppSpacing.lg,
        InfoBanner(
          message:
              '🔒 Your phone and email will be hidden. Finders will contact you through the app.',
          type: InfoBannerType.info,
        ),
        AppSpacing.lg,

        // Submit button (visible only in review step)
        BlocBuilder<AlertCubit, AlertState>(
          builder: (context, alertState) {
            final isSubmitting = alertState is AlertLoading;
            return AppButton(
              text: 'Submit Alert',
              isLoading: isSubmitting,
              icon: Icons.warning_amber_rounded,
              type: AppButtonType.primary,
              isFullWidth: true,
              onPressed: isSubmitting ? null : _submitAlert,
            );
          },
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
            width: 100,
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
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Bottom bar — Back / Continue
  // ────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    final isLastStep = _currentStep == _stepLabels.length - 1;

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
          // On the last step the Continue button is hidden —
          // the Submit button lives inside the review content instead.
          if (!isLastStep)
            Expanded(
              child: AppButton(
                text: 'Continue',
                onPressed: _canProceed ? _nextStep : null,
              ),
            ),
        ],
      ),
    );
  }
}
