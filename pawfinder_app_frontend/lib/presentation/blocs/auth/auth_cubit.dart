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

  // ── Google Sign-In ────────────────────────────────────────────

  /// Sign in with Google. Uses the backend's existing OAuth login endpoint.
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    try {
      final googleUser = await _authService.signInWithGoogle();
      if (googleUser == null) {
        emit(AuthInitial());
        return;
      }

      final result = await _authRepository.login(
        authProvider: 'google',
        authId: googleUser.id,
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

  // ── Phone auth (legacy — still supported by backend) ──────────

  /// Register with phone number. Sends SMS verification code.
  Future<void> register(String phoneNumber) async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.registerPhone(phoneNumber);

      result.fold(
        (failure) => emit(AuthError(message: failure.message)),
        (_) => emit(AuthCodeSent(phoneNumber: phoneNumber)),
      );
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Verify the SMS code and complete phone auth login.
  Future<void> verifyCode(String phoneNumber, String code) async {
    emit(AuthLoading());

    try {
      final result =
          await _authRepository.verifyPhone(phoneNumber, code);

      result.fold(
        (failure) => emit(AuthVerificationFailed(message: failure.message)),
        (user) {
          _currentUser = user;
          emit(AuthAuthenticated(user: user));
        },
      );
    } catch (e) {
      emit(AuthVerificationFailed(message: e.toString()));
    }
  }

  /// Navigate back from SMS code entry to phone input.
  void backToPhone() {
    emit(AuthInitial());
  }

  // ── Dev sign-in ───────────────────────────────────────────────

  /// Dev-only sign-in — bypasses Google OAuth for local testing.
  Future<void> signInDev() async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.login(
        authProvider: 'google',
        authId: 'dev-user-0001',
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
    await _authService.deleteToken();
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
}
