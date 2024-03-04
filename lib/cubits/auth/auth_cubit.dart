import 'package:chats/helpers/validator.dart';
import 'package:chats/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(AuthState.initial());

  void emailChanged(String? value) {
    emit(state.copyWith(email: value, status: AuthStatus.initial));
  }

  void passwordChanged(String? value) {
    emit(state.copyWith(password: value, status: AuthStatus.initial));
  }

  void phoneChanged(String? value) {
    emit(state.copyWith(phone: value, status: AuthStatus.initial));
  }

  void repeatPasswordChanged(String? value) {
    emit(state.copyWith(repeatPassword: value, status: AuthStatus.initial));
  }

  void changeObscurePasswordStatus(bool value) {
    emit(state.copyWith(obscurePassword: !value, status: AuthStatus.initial));
  }

  Future<void> sendSMS() async {
    emit(state.copyWith(status: AuthStatus.submitting));
    await _authRepository.verifyPhoneNumber(
        phone: state.phone,
        onCodeSent: (verificationId, resendToken) => emit(state.copyWith(
            verificationId: verificationId, status: AuthStatus.codeSent)),
        onError: () {emit(state.copyWith(status: AuthStatus.error));});
  }

  Future<void> loginWithSMSCode({required String smsCode}) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId, smsCode: smsCode);
    final user =
        await _authRepository.signInWithCredential(credential: credential);
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> sendVerificationEmail(bool isResend) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    String result = await _authRepository.sendVerificationEmail();
    if (result == 'success') {
      isResend ? emit(state.copyWith(status: AuthStatus.success)) : null;
    } else if (result == 'too-many-requests') {
      emit(state.copyWith(status: AuthStatus.toManyRequests));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(state.copyWith(status: AuthStatus.submitting));

    String result = await _authRepository.sendPasswordResetEmail(email);
    if (result == 'success') {
      emit(state.copyWith(status: AuthStatus.success));
    } else if (result == 'user-not-found') {
      emit(state.copyWith(status: AuthStatus.emailNotFound));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> loginWithPasswordAndEmail() async {
    emit(state.copyWith(status: AuthStatus.submitting));
    User? user = await _authRepository.signIn(
      email: state.email,
      password: state.password,
    );
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } else {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> registerWithEmailAndPassword() async {
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      User? user = await _authRepository.register(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(state.copyWith(status: AuthStatus.emailInUse));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}