import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:chats/repository/auth_repository.dart';
import 'package:chats/screens/auth/widgets/email_input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/main_logo.dart';

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});

  final _emailInputController = TextEditingController();

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
                          'Remember your email?',
                          style: TextStyle(fontSize: 16),
                        ))),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: EmailTextInput(_emailInputController, 'Email')),
                Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onPressed:
                      state.isEmailValid
                          ? () =>
                              context.read<AuthCubit>().sendPasswordResetEmail(state.email)
                          : null,
                      child:
                          // state.status == AuthStatus.submitting
                          //     ? const CircularProgressIndicator(color: Colors.white)
                          //     :
                          const Text('Reset password',
                              style: TextStyle(fontSize: 20)),
                    )),
              ],
            ),
          );
        }));
  }
}
