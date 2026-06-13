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

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.login(email: email, password: password);

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

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(AuthLoading());

    try {
      final result = await _authRepository.register(
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

  Future<void> logout() async {
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

  /// Refresh the current user data.
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
