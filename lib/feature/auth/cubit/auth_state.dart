part of 'auth_cubit.dart';

enum AuthStatus {
  initial,
  submitting,
  success,
  successByFacebookProvider,
  codeSent,
  error
}

class AuthState extends Equatable {
  final String email;
  final String password;
  final String repeatPassword;
  final AuthStatus status;
  final bool obscurePassword;
  final String phone;
  final String verificationId;
  final String errorText;
  final User? user;

  const AuthState(
      {required this.email,
      required this.password,
      required this.repeatPassword,
      required this.status,
      required this.phone,
      required this.verificationId,
      required this.obscurePassword,
      required this.errorText,
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
        errorText,
        verificationId
      ];

  factory AuthState.initial() {
    return const AuthState(
        phone: '',
        verificationId: '',
        email: '',
        password: '',
        repeatPassword: '',
        errorText: '',
        status: AuthStatus.initial,
        obscurePassword: true);
  }

  AuthState copyWith({
    String? email,
    String? phone,
    String? verificationId,
    String? password,
    String? repeatPassword,
    String? errorText,
    AuthStatus? status,
    bool? obscurePassword,
    User? user,
  }) {
    return AuthState(
        email: email ?? this.email,
        phone: phone ?? this.phone,
        errorText: errorText ?? this.errorText,
        verificationId: verificationId ?? this.verificationId,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        user: user ?? this.user);
  }
}
