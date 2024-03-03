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

  void repeatPasswordChanged(String? value) {
    emit(state.copyWith(repeatPassword: value, status: AuthStatus.initial));
  }

  void changeObscurePasswordStatus(bool value) {
    emit(state.copyWith(obscurePassword: !value, status: AuthStatus.initial));
  }

  Future<void> sendVerificationEmail(bool isResend) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      await _authRepository.sendVerificationEmail();
      isResend ? emit(state.copyWith(status: AuthStatus.success)) : null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        emit(state.copyWith(status: AuthStatus.toManyRequests));
      } else {
        emit(state.copyWith(status: AuthStatus.error));
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      await _authRepository.sendPasswordResetEmail(email);
      emit(state.copyWith(status: AuthStatus.success));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(state.copyWith(status: AuthStatus.emailNotFound));
      } else {
        emit(state.copyWith(status: AuthStatus.error));
      }
    }
  }

  Future<void> loginWithCredentials() async {
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


/*  Firebase answer:
User(displayName: null, email: moyseyenko.av@gmail.com, isEmailVerified: false, 
isAnonymous: false, metadata: UserMetadata(creationTime: 2024-02-27 12:28:32.620Z, 
lastSignInTime: 2024-02-27 14:44:43.778Z), phoneNumber: null, photoURL: null, 
providerData, [UserInfo(displayName: null, email: moyseyenko.av@gmail.com, 
phoneNumber: null, photoURL: null, providerId: password, uid: moyseyenko.av@gmail.com)],
 refreshToken: null, tenantId: null, uid: 1Y9BZ3nSvjZKte5Qp1xVzYzSM8z2)
 */