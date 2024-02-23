part of 'auth_cubit.dart';

abstract class AuthState {
  String? email;
  String? pass;
  bool? obscure;
  AuthState({this.email = '', this.pass = '', this.obscure = true});

}

class AuthInitial extends AuthState {}

class AuthValidation extends AuthState {
  AuthValidation({String? pass,bool? obscure, String? email}):super();
}

class AuthChecking extends AuthState {}

class AuthSuccess extends AuthState {}
