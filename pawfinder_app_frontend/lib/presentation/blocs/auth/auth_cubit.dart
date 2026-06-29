import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pawfinder_app/domain/entities/user.dart';
import 'package:pawfinder_app/domain/repositories/auth_repository.dart';
import 'package:pawfinder_app/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final AuthService _authService;

  AuthCubit({
    required AuthRepository authRepository,
    required AuthService authService,
  })  : _authRepository = authRepository,
        _authService = authService,
        super(AuthInitial());

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // ── Email + Password ──────────────────────────────────────────

  /// Register with email + password. Backend auto-logs in.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) {
          _currentUser = user;
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Sign in with email + password.
  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.loginWithEmail(
        email: email,
        password: password,
      );

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (user) {
          _currentUser = user;
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // ── Session management ────────────────────────────────────────

  void clearError() {
    emit(AuthInitial());
  }

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    emit(AuthInitial());
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    try {
      final isAuth = await _authService.isAuthenticated();
      if (!isAuth) {
        emit(AuthInitial());
        return;
      }

      final result = await _authRepository.getCurrentUser();

      result.fold(
        (failure) {
          _authService.deleteToken();
          emit(AuthInitial());
        },
        (user) {
          _currentUser = user;
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      emit(AuthInitial());
    }
  }

  Future<void> refreshUser() async {
    try {
      final result = await _authRepository.getCurrentUser();
      result.fold(
        (_) {},
        (user) {
          _currentUser = user;
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (_) {}
  }

  // ── Phone auth stubs (removed — kept for build compat) ──────────

  /// Phone verification is no longer supported (email/password auth only).
  @Deprecated('Phone auth removed. Use email/password sign-in.')
  Future<void> verifyCode(String phoneNumber, String code) async {
    emit(AuthError(
      message: 'Phone verification is no longer supported. '
          'Please use email/password to sign in.',
    ));
  }

  /// Phone registration is no longer supported (email/password auth only).
  @Deprecated('Phone auth removed. Use email/password sign-up.')
  Future<void> register(String phoneNumber) async {
    emit(AuthError(
      message: 'Phone registration is no longer supported. '
          'Please use email/password to sign up.',
    ));
  }

  /// Navigate back to phone entry (no-op — phone auth removed).
  @Deprecated('Phone auth removed.')
  void backToPhone() {
    clearError();
  }
}
