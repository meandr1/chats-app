import 'package:chats/feature/auth/interface/auth_interface.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/feature/auth/repository/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> implements AuthInterface {
  final AuthRepository _authRepository;
  final String unknownError = 'An unknown error occurred';
  AuthCubit(this._authRepository) : super(AuthState.initial());

  @override
  bool get isEmailValid {
    return Validator.emailValidator(state.email) == null;
  }

  @override
  bool get isPhoneValid {
    return Validator.phoneValidator(state.phone) == null;
  }

  @override
  bool get isSignFormsValid {
    return Validator.passValidator(state.password) == null &&
        Validator.emailValidator(state.email) == null;
  }

  @override
  bool get isRegisterFormsValid {
    return Validator.passValidator(state.password) == null &&
        (state.password == state.repeatPassword || !state.obscurePassword) &&
        Validator.emailValidator(state.email) == null;
  }

  @override
  void emailChanged(String? value) {
    emit(state.copyWith(email: value, status: AuthStatus.initial));
  }

  @override
  void passwordChanged(String? value) {
    emit(state.copyWith(password: value, status: AuthStatus.initial));
  }

  @override
  void phoneChanged(String? value) {
    emit(state.copyWith(phone: value, status: AuthStatus.initial));
  }

  @override
  void repeatPasswordChanged(String? value) {
    emit(state.copyWith(repeatPassword: value, status: AuthStatus.initial));
  }

  @override
  void changeObscurePasswordStatus(bool value) {
    emit(state.copyWith(obscurePassword: !value, status: AuthStatus.initial));
  }

  @override
  Future<void> sendSMS() async {
    emit(state.copyWith(status: AuthStatus.submitting));
    await _authRepository.verifyPhoneNumber(
        phone: state.phone,
        onCodeSent: (verificationId, resendToken) => emit(state.copyWith(
            verificationId: verificationId, status: AuthStatus.codeSent)),
        onError: (error) {
          emit(state.copyWith(
              status: AuthStatus.error, errorText: error ?? unknownError));
        });
  }

  @override
  Future<void> loginWithSMSCode({required String smsCode}) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: state.verificationId, smsCode: smsCode);
      final user =
          await _authRepository.signInWithCredential(credential: credential);
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error, errorText: e.message ?? unknownError));
    }
  }

  @override
  Future<void> sendVerificationEmail({required bool isResend}) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    String? result = await _authRepository.sendVerificationEmail();
    if (result == 'success') {
      isResend ? emit(state.copyWith(status: AuthStatus.success)) : null;
    } else {
      emit(state.copyWith(
          status: AuthStatus.error, errorText: result ?? unknownError));
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    String? result = await _authRepository.sendPasswordResetEmail(email);
    if (result == 'success') {
      emit(state.copyWith(status: AuthStatus.success));
    } else {
      emit(state.copyWith(
          status: AuthStatus.error, errorText: result ?? unknownError));
    }
  }

  @override
  Future<void> loginWithPasswordAndEmail() async {
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      User? user = await _authRepository.signIn(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error, errorText: e.message ?? unknownError));
    }
  }

  @override
  Future<void> registerWithEmailAndPassword() async {
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      User? user = await _authRepository.register(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error, errorText: e.message ?? unknownError));
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    OAuthCredential userCredential;
    User? user;
    try {
      userCredential = await _authRepository.getGoogleCredentials();
      try {
        user = await _authRepository.signInWithCredential(
            credential: userCredential);
        emit(state.copyWith(status: AuthStatus.success, user: user));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            status: AuthStatus.error, errorText: e.message ?? unknownError));
      }
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error,
          errorText: 'An error occurred during Google login'));
    }
  }

  @override
  Future<void> signInWithFacebook() async {
    OAuthCredential userCredential;
    User? user;
    try {
      userCredential = await _authRepository.getFacebookCredentials();
      try {
        user = await _authRepository.signInWithCredential(
            credential: userCredential);
        emit(state.copyWith(
            status: AuthStatus.successByFacebookProvider, user: user));
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            status: AuthStatus.error, errorText: e.message ?? unknownError));
      }
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error,
          errorText: 'An error occurred during facebook login'));
    }
  }
}
