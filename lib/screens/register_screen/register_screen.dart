import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/repository/auth_repository.dart';
import 'package:chats/screens/auth/email_input_text_field.dart';
import 'package:chats/screens/auth/pass_input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../main_logo.dart';

class RegisterScreen extends StatelessWidget with Validator {
  RegisterScreen({super.key});

  final _emailInputController = TextEditingController();
  final _passInputController = TextEditingController();
  final _passRepeatInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(AuthRepository(firebaseAuth: FirebaseAuth.instance)),
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (BuildContext context, AuthState state) {
          // if (state.status == AuthStatus.success) {
          //   context.go('/');
          // } else if (state.status == AuthStatus.error) {
          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //       content: Text('Login or password is incorrect')));
          // }
        }, builder: (context, state) {
          return Scaffold(
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
                          'Register a new account',
                          style: TextStyle(fontSize: 16),
                        ))),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: EmailTextInput(_emailInputController, 'Email')),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 15),
                    child: PassTextInput(
                        controller: _passInputController,
                        labelText: 'Password',
                        showIcon: true,
                        textInputAction: TextInputAction.next,

                        validator: passValidator)),
                Visibility(
                    visible: state.obscurePassword,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 15),
                        child: PassTextInput(
                            controller: _passRepeatInputController,
                            labelText: 'Password',
                            showIcon: false,
                            textInputAction: TextInputAction.done,
                            validator: (password) => _passInputController.text == password
                                ? null
                                : 'Password didn`t match'))),
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
                      // state.isFormsValid
                      //     ? () =>
                      //         context.read<AuthCubit>().loginWithCredentials()
                      //     : null,
                      child:
                          // state.status == AuthStatus.submitting
                          //     ? const CircularProgressIndicator(color: Colors.white)
                          //     :
                          const Text('Register',
                              style: TextStyle(fontSize: 20)),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'I have an account!',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => context.go('/EmailAuthScreen'),
                      child:
                          const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
