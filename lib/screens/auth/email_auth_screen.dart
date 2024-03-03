import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/repository/auth_repository.dart';
import 'package:chats/screens/auth/widgets/alternative_sign_in_methods.dart';
import 'package:chats/screens/auth/widgets/email_input_text_field.dart';
import 'package:chats/screens/auth/widgets/login_divider.dart';
import 'package:chats/screens/auth/widgets/pass_input_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';

class EmailAuthScreen extends StatelessWidget with Validator {
  EmailAuthScreen({super.key});

  final _emailInputController = TextEditingController();
  final _passInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(AuthRepository(firebaseAuth: FirebaseAuth.instance)),
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (BuildContext context, AuthState state) {
          if (state.status == AuthStatus.success) {
            if (state.user!.emailVerified) {
              context.go('/');
            } else {
              context.read<AuthCubit>().sendVerificationEmail(false);
              context.go('/SendVerifyLetterScreen');
            }
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Login or password is incorrect')));
          }
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
                          'Sign in to your account',
                          style: TextStyle(fontSize: 16),
                        ))),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: EmailTextInput(_emailInputController, 'Email')),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: PassTextInput(
                      controller: _passInputController,
                      labelText: 'Password',
                      showIcon: true,
                      textInputAction: TextInputAction.done,
                      validator: passValidator,
                      isRepeatForm: false,
                    )),
                Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.go('/ForgotPassScreen'),
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
                      onPressed: state.isSignFormsValid
                          ? () => context
                              .read<AuthCubit>()
                              .loginWithPasswordAndEmail()
                          : null,
                      child: state.status == AuthStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login', style: TextStyle(fontSize: 20)),
                    )),
                const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 18),
                    child: LoginDivider()),
                const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: AlternativeSignInMethods()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don`t have an account?',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () => context.go('/RegisterScreen'),
                      child: const Text('Register',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
