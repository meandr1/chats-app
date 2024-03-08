part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  submitting,
  success,
  successByFacebookProvider,
  emailInUse,
  toManyRequests,
  emailNotFound,
  codeSent,
  error,
  emailAuthError,
  googleAuthError,
  facebookAuthError
}

class AuthState extends Equatable {
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

  @override
  List<Object?> get props => [
        email,
        password,
        repeatPassword,
        status,
        obscurePassword,
        user,
        phone,
        verificationId
      ];

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
