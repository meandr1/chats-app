import 'package:chats/bloc/cubit/auth_cubit.dart';
import 'package:chats/screens/auth/email_input_text_field.dart';
import 'package:chats/screens/auth/pass_input_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
          // resizeToAvoidBottomInset: false,
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: PassTextInput(
                    _passInputController,
                    'Password',
                  )),
              Padding(
                  padding: const EdgeInsets.only(right: 20),
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 18),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Or login with'),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onPressed: () {},
                      icon: Icon(Icons.phone,
                          size: 20, color: Colors.grey.shade500),
                      label: const Text('Phone'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/google.png',
                        scale: 5,
                      ),
                      label: const Text('Google'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/facebook.png',
                        scale: 4.5,
                      ),
                      label: const Text('Facebook'),
                    ),
                  ),
                  const SizedBox(width: 20)
                ],
              )
            ],
          ),
        ));
  }
}
