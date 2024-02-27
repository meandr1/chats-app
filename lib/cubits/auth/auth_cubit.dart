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
    print('email changed');
    emit(state.copyWith(email: value, status: AuthStatus.initial));
  }

  void passwordChanged(String? value) {
    print('password changed');
    emit(state.copyWith(password: value, status: AuthStatus.initial));
  }

  void changeObscurePasswordStatus(bool value) {
    emit(state.copyWith(obscurePassword: !value, status: AuthStatus.initial));
  }

  Future<void> loginWithCredentials() async {
    emit(state.copyWith(status: AuthStatus.submitting));
    User? user = await _authRepository.signUp(
      email: state.email,
      password: state.password,
    );
    print('USER = $user');
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.success, user: user));
    } else {
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