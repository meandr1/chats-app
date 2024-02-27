part of 'auth_cubit.dart';

enum AuthStatus { initial, submitting, success, error }

class AuthState extends Equatable with Validator {
  final String email;
  final String password;
  final AuthStatus status;
  final bool obscurePassword;
  final User? user;

  AuthState(
      {required this.email,
      required this.password,
      required this.status,
      required this.obscurePassword,
      this.user});

  bool get isFormsValid {
    return passValidator(password) == null && emailValidator(email) == null;
  }

  //   String? get isEmailValid {
  //   return emailValidator(email);
  // }
  //     String? get isPasswordValid {
  //   return passValidator(password);
  // }

  @override
  List<Object?> get props => [email, password, status, obscurePassword, user];

  factory AuthState.initial() {
    return AuthState(
        email: '',
        password: '',
        status: AuthStatus.initial,
        obscurePassword: true);
  }

  AuthState copyWith({
    String? email,
    String? password,
    AuthStatus? status,
    bool? obscurePassword,
    User? user,
  }) {
    return AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        user: user ?? this.user);
  }
}
