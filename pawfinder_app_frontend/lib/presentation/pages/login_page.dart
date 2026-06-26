import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/textured_background.dart';

/// Sign-in / sign-up page — email + password only.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showSignUp = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  void _submit(AuthCubit cubit) {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_showSignUp) {
      final name = _displayNameController.text.trim();
      cubit.signUpWithEmail(
        email: email,
        password: password,
        displayName: name.isNotEmpty ? name : null,
      );
    } else {
      cubit.signInWithEmail(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final isLoading = state is AuthLoading;
    final error = state is AuthError ? state.message : null;

    return TexturedBackground(
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
            onPressed: () => context.go('/onboarding'),
          ),
        ),
        body: SafeArea(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                context.go('/home');
              }
            },
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Hero Icon
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusXl + 4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.pets_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),

                    AppSpacing.xxl,

                    Text(
                      _showSignUp ? 'Create account' : 'Welcome back',
                      style: AppTypography.h1.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.sm,
                    Text(
                      _showSignUp
                          ? 'Join PawFinder and help reunite\nlost pets with their community.'
                          : 'Sign in to report lost pets, get alerts,\nand help your community.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.ink500,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    AppSpacing.xxl,

                    // Auth Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.ink100),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink900.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Display name (sign-up only)
                            if (_showSignUp) ...[
                              _buildTextField(
                                controller: _displayNameController,
                                hint: 'Your name',
                                icon: Icons.person_outline,
                                textInputAction: TextInputAction.next,
                                enabled: !isLoading,
                              ),
                              AppSpacing.md,
                            ],

                            // Email
                            _buildTextField(
                              controller: _emailController,
                              hint: 'you@example.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enabled: !isLoading,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!v.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            AppSpacing.md,

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              enabled: !isLoading,
                              onFieldSubmitted: (_) =>
                                  _submit(context.read<AuthCubit>()),
                              style: AppTypography.body
                                  .copyWith(color: AppColors.ink900),
                              decoration: InputDecoration(
                                hintText: _showSignUp
                                    ? 'Min. 8 characters'
                                    : 'Your password',
                                hintStyle: AppTypography.body
                                    .copyWith(color: AppColors.ink300),
                                filled: true,
                                fillColor: AppColors.surface,
                                prefixIcon: const Icon(Icons.lock_outline,
                                    color: AppColors.ink500, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.ink500,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(() =>
                                      _obscurePassword = !_obscurePassword),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: AppColors.ink100),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: AppColors.ink100),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                      color: AppColors.primary, width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(
                                      color: AppColors.danger),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Password is required';
                                }
                                if (_showSignUp && v.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            AppSpacing.xl,

                            // Submit
                            AppButton(
                              text: _showSignUp ? 'Create Account' : 'Sign In',
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () => _submit(context.read<AuthCubit>()),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (error != null) ...[
                      AppSpacing.lg,
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.danger, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                error,
                                style: AppTypography.bodySmall
                                    .copyWith(color: AppColors.danger),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    AppSpacing.lg,

                    // Toggle sign-in / sign-up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _showSignUp
                              ? 'Already have an account?'
                              : "Don't have an account?",
                          style: AppTypography.bodySmall
                              .copyWith(color: AppColors.ink500),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _showSignUp = !_showSignUp;
                                    _formKey.currentState?.reset();
                                  });
                                  context.read<AuthCubit>().clearError();
                                },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(left: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            _showSignUp ? 'Sign In' : 'Sign Up',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.sm,
                    Text(
                      'Your information stays private.\nWe never share your data.',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.ink300, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.xxl,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      style: AppTypography.body.copyWith(color: AppColors.ink900),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.body.copyWith(color: AppColors.ink300),
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: Icon(icon, color: AppColors.ink500, size: 20),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.ink100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.ink100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      validator: validator,
    );
  }
}
