part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  submitting,
  success,
  error,
  emailInUse,
  toManyRequests,
  emailNotFound,
  codeSent
}

class AuthState extends Equatable with Validator {
  final String email;
  final String password;
  final String repeatPassword;
  final AuthStatus status;
  final bool obscurePassword;
  final String phone;
  final String verificationId;
  final User? user;

  AuthState(
      {required this.email,
      required this.password,
      required this.repeatPassword,
      required this.status,
      required this.phone,
      required this.verificationId,
      required this.obscurePassword,
      this.user});

  bool get isEmailValid {
    return emailValidator(email) == null;
  }

    bool get isPhoneValid {
    return phoneValidator(phone) == null;
  }

  bool get isSignFormsValid {
    return passValidator(password) == null && emailValidator(email) == null;
  }

  bool get isRegisterFormsValid {
    return passValidator(password) == null &&
        (password == repeatPassword || !obscurePassword) &&
        emailValidator(email) == null;
  }

  @override
  List<Object?> get props =>
      [email, password, repeatPassword, status, obscurePassword, user, phone,verificationId];

  factory AuthState.initial() {
    return AuthState(
        phone: '',
        verificationId: '',
        email: '',
        password: '',
        repeatPassword: '',
        status: AuthStatus.initial,
        obscurePassword: true);
  }

  AuthState copyWith({
    String? email,
    String? phone,
    String? verificationId,
    String? password,
    String? repeatPassword,
    AuthStatus? status,
    bool? obscurePassword,
    User? user,
  }) {
    return AuthState(
        email: email ?? this.email,
        phone: phone ?? this.phone,
        verificationId: verificationId ?? this.verificationId,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        user: user ?? this.user);
  }
}
