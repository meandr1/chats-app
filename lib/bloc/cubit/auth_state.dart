part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthValidation extends AuthState {
  String? email;
  String? pass;
  bool obscure;
  AuthValidation({this.email = '', this.pass = '', this.obscure = true});
}

class AuthChecking extends AuthState {}

class AuthSuccess extends AuthState {}
