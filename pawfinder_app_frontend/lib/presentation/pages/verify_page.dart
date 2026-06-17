import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../di/injection.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/textured_background.dart';

/// SMS verification code entry — second step of the auth flow.
class VerifyPage extends StatefulWidget {
  final String phoneNumber;

  const VerifyPage({super.key, required this.phoneNumber});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _codeController = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _resendTimer;
  int _resendSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Auto-focus the code field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _focusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendCooldown() {
    setState(() => _resendSeconds = 30);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 1) {
        timer.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  void _submit(AuthCubit cubit) {
    final code = _codeController.text.trim();
    if (code.length < 4) return;
    cubit.verifyCode(widget.phoneNumber, code);
  }

  void _resend(AuthCubit cubit) {
    cubit.register(widget.phoneNumber);
    _startResendCooldown();
  }

  /// Format phone for display: +2781... → +27 81 234 5678
  String _formatPhone(String phone) {
    if (phone.startsWith('+27') && phone.length == 12) {
      return '${phone.substring(0, 3)} ${phone.substring(3, 5)} ${phone.substring(5, 8)} ${phone.substring(8)}';
    }
    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthCubit>(),
      child: TexturedBackground(
        mode: BackgroundMode.warmGlass,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.ink700, size: 20),
              onPressed: () {
                context.read<AuthCubit>().backToPhone();
                context.pop();
              },
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      context.go('/home');
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    final error = state is AuthVerificationFailed
                        ? state.message
                        : state is AuthError
                            ? state.message
                            : null;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shield icon
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryLight,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusXl),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            size: 40,
                            color: AppColors.secondary,
                          ),
                        ),
                        AppSpacing.xl,

                        // Title
                        Text(
                          'Verify your phone',
                          style: AppTypography.h1.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        AppSpacing.sm,
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: AppTypography.body.copyWith(
                              color: AppColors.ink500,
                            ),
                            children: [
                              const TextSpan(text: 'Enter the 6-digit code sent to '),
                              TextSpan(
                                text: _formatPhone(widget.phoneNumber),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSpacing.xxl,

                        // Code input
                        TextFormField(
                          controller: _codeController,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          enabled: !isLoading,
                          onChanged: (value) {
                            if (value.length == 6) {
                              _submit(context.read<AuthCubit>());
                            }
                          },
                          style: AppTypography.displayMedium.copyWith(
                            color: AppColors.ink900,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 12,
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: '123456',
                            hintStyle: AppTypography.displayMedium.copyWith(
                              color: AppColors.ink300,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.ink100),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppColors.ink100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: AppColors.secondary,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                  color: AppColors.danger),
                            ),
                          ),
                        ),
                        AppSpacing.sm,

                        // Dev hint
                        Text(
                          'Dev mode: use code 123456',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.ink300,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        AppSpacing.xl,

                        // Error
                        if (error != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.dangerLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: AppColors.danger, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    error,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.danger,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppSpacing.lg,
                        ],

                        // Submit button
                        AppButton(
                          text: 'Verify',
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () => _submit(context.read<AuthCubit>()),
                        ),
                        AppSpacing.lg,

                        // Resend
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code?",
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.ink500,
                              ),
                            ),
                            if (_resendSeconds > 0)
                              Text(
                                ' Resend in ${_resendSeconds}s',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.ink300,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else
                              TextButton(
                                onPressed:
                                    isLoading ? null : () => _resend(context.read<AuthCubit>()),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.only(left: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Resend',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        AppSpacing.xxl,
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
