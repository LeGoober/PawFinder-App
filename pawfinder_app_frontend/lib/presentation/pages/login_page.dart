import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../blocs/auth/auth_cubit.dart';
import '../widgets/app_button.dart';
import '../widgets/textured_background.dart';

/// Sign-in page with tabbed Google OAuth and Email/Password auth.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
                    // ── Hero Icon ──────────────────────────
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
                      'Welcome to PawFinder',
                      style: AppTypography.h1.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.sm,
                    Text(
                      'Sign in to report lost pets, get alerts,\nand help your community.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.ink500,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    AppSpacing.xxl,

                    // ── Tab Bar ────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.ink100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.ink900
                                  .withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: AppColors.ink900,
                        unselectedLabelColor: AppColors.ink500,
                        labelStyle: AppTypography.button.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        unselectedLabelStyle: AppTypography.button.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: 'Google'),
                          Tab(text: 'Email'),
                        ],
                      ),
                    ),

                    AppSpacing.xl,

                    // ── Tab Content ────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: IndexedStack(
                          index: _tabController.index,
                          children: const [
                            _GoogleSignInTab(),
                            _EmailSignInTab(),
                          ],
                        ),
                      ),
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
}

// ═══════════════════════════════════════════════════════════════
// Google Sign-In Tab
// ═══════════════════════════════════════════════════════════════

class _GoogleSignInTab extends StatelessWidget {
  const _GoogleSignInTab();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    final isLoading = state is AuthLoading;
    final error = state is AuthError ? state.message : null;

    return Column(
      children: [
        _AuthCard(
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFDADCE0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(11),
                  child: CustomPaint(
                    painter: _GoogleLogoPainter(),
                    size: const Size(26, 26),
                  ),
                ),
              ),
              AppSpacing.lg,
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => context.read<AuthCubit>().signInWithGoogle(),
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.ink700,
                          ),
                        )
                      : const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink900,
                          ),
                        ),
                  label: Text(
                    isLoading ? 'Signing in...' : 'Continue with Google',
                    style: AppTypography.button.copyWith(
                      color: AppColors.ink900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.ink900,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: const BorderSide(
                        color: Color(0xFFDADCE0),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null) ...[AppSpacing.lg, _ErrorBanner(message: error)],
        // Dev sign-in (debug only)
        if (kDebugMode) ...[
          AppSpacing.lg,
          const Divider(color: AppColors.ink100),
          AppSpacing.md,
          TextButton.icon(
            onPressed: isLoading
                ? null
                : () => context.read<AuthCubit>().signInDev(),
            icon: const Icon(Icons.developer_mode,
                size: 18, color: AppColors.ink300),
            label: Text(
              'Dev sign-in (skip Google)',
              style: AppTypography.caption.copyWith(color: AppColors.ink300),
            ),
          ),
        ],
        AppSpacing.lg,
        Text(
          'Your information stays private.\nWe never share your data.',
          style:
              AppTypography.caption.copyWith(color: AppColors.ink300, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Email Sign-In Tab
// ═══════════════════════════════════════════════════════════════

class _EmailSignInTab extends StatefulWidget {
  const _EmailSignInTab();

  @override
  State<_EmailSignInTab> createState() => _EmailSignInTabState();
}

class _EmailSignInTabState extends State<_EmailSignInTab> {
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

    return Column(
      children: [
        _AuthCard(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Tab title
                Text(
                  _showSignUp ? 'Create account' : 'Sign in with email',
                  style: AppTypography.h3.copyWith(fontWeight: FontWeight.w700),
                ),
                AppSpacing.lg,

                // Display name (sign-up only)
                if (_showSignUp) ...[
                  TextFormField(
                    controller: _displayNameController,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                    style: AppTypography.body.copyWith(color: AppColors.ink900),
                    decoration: InputDecoration(
                      hintText: 'Your name',
                      hintStyle: AppTypography.body.copyWith(
                          color: AppColors.ink300),
                      filled: true,
                      fillColor: AppColors.surface,
                      prefixIcon: const Icon(Icons.person_outline,
                          color: AppColors.ink500, size: 20),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
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
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.danger),
                      ),
                    ),
                  ),
                  AppSpacing.md,
                ],

                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  style: AppTypography.body.copyWith(color: AppColors.ink900),
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    hintStyle: AppTypography.body.copyWith(
                        color: AppColors.ink300),
                    filled: true,
                    fillColor: AppColors.surface,
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: AppColors.ink500, size: 20),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
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
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.danger),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
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
                  onFieldSubmitted: (_) => _submit(context.read<AuthCubit>()),
                  style: AppTypography.body.copyWith(color: AppColors.ink900),
                  decoration: InputDecoration(
                    hintText: _showSignUp
                        ? 'Min. 8 characters'
                        : 'Your password',
                    hintStyle: AppTypography.body.copyWith(
                        color: AppColors.ink300),
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
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
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
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.danger),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
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
                  onPressed:
                      isLoading ? null : () => _submit(context.read<AuthCubit>()),
                ),
              ],
            ),
          ),
        ),

        if (error != null) ...[AppSpacing.lg, _ErrorBanner(message: error)],

        AppSpacing.lg,

        // Toggle sign-in / sign-up
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showSignUp
                  ? 'Already have an account?'
                  : "Don't have an account?",
              style: AppTypography.bodySmall.copyWith(color: AppColors.ink500),
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
          style:
              AppTypography.caption.copyWith(color: AppColors.ink300, height: 1.5),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Shared Widgets
// ═══════════════════════════════════════════════════════════════

class _AuthCard extends StatelessWidget {
  final Widget child;
  const _AuthCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySmall.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple multi-color Google "G" logo painter.
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFF4285F4);
    canvas.drawRRect(
      RRect.fromLTRBR(
          size.width * 0.45, 0, size.width, size.height * 0.55,
          const Radius.circular(99)),
      paint,
    );
    paint.color = const Color(0xFFEA4335);
    canvas.drawRRect(
      RRect.fromLTRBR(0, 0, size.width * 0.55, size.height * 0.55,
          const Radius.circular(99)),
      paint,
    );
    paint.color = const Color(0xFFFBBC04);
    canvas.drawRRect(
      RRect.fromLTRBR(
          0, size.height * 0.45, size.width * 0.55, size.height,
          const Radius.circular(99)),
      paint,
    );
    paint.color = const Color(0xFF34A853);
    canvas.drawRRect(
      RRect.fromLTRBR(
          size.width * 0.45, size.height * 0.45, size.width, size.height,
          const Radius.circular(99)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
