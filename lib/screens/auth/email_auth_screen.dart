import 'package:chats/bloc/cubit/auth_cubit.dart';
import 'package:chats/screens/auth/alternative_sign_in_methods.dart';
import 'package:chats/screens/auth/email_input_text_field.dart';
import 'package:chats/screens/auth/login_divider.dart';
import 'package:chats/screens/auth/pass_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_logo.dart';

class EmailAuthScreen extends StatelessWidget {
  EmailAuthScreen({super.key});

  final _emailInputController = TextEditingController();
  final _passInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: MainLogo(),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Sign in to your account',
                        style: TextStyle(fontSize: 16),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: EmailTextInput(
                    _emailInputController,
                    'Email',
                    autofocus: true,
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: PassTextInput(
                    _passInputController,
                    'Password',
                  )),
              Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 10),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?',
                            style: TextStyle(fontSize: 16)),
                      ))),
              Padding(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12)))),
                    onPressed: () {},
                    child: const Text('Login', style: TextStyle(fontSize: 20)),
                  )),
              const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 18),
                  child: LoginDivider()),
              const AlternativeSignInMethods()
            ],
          ),
        ));
  }
}
