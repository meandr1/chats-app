import 'package:chats/screens/auth/email_input_text_field.dart';
import 'package:chats/screens/auth/pass_input_text_field.dart';
import 'package:flutter/material.dart';
import 'main_logo.dart';

class EmailAuthScreen extends StatelessWidget {
  EmailAuthScreen({super.key});

  final _emailInputController = TextEditingController();
  final _passInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const MainLogo(),
          const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Sign in to your account',
                style: TextStyle(fontSize: 16),
              )),
          Padding(
              padding: const EdgeInsets.all(20),
              child: EmailTextInput(_emailInputController, 'Email', autofocus: true,)),
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: PassTextInput(_passInputController, 'Password'))
        ],
      ),
    );
  }
}
