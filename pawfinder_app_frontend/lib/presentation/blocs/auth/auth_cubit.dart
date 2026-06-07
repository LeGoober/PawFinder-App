import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthAuthenticated(userId: 'mock-user-id', displayName: 'Alex'));
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AuthInitial());
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(milliseconds: 800));
    emit(AuthInitial());
  }
}
