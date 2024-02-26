import 'package:chats/helpers/validator.dart';
import 'package:chats/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: AuthStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: AuthStatus.initial));
  }

  void changeObscurePasswordStatus(bool value) {
    emit(state.copyWith(obscurePassword: !value, status: AuthStatus.initial));
  }

  Future<void> signUpWithCredentials() async {
    emit(state.copyWith(status: AuthStatus.submitting));

    User? user = await _authRepository.signUp(
      email: state.email,
      password: state.password,
    );
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}
