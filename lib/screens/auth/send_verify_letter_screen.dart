import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';

class SendVerifyLetterScreen extends StatelessWidget with Validator {
  final String email;
  SendVerifyLetterScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(AuthRepository(firebaseAuth: FirebaseAuth.instance)),
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (BuildContext context, AuthState state) {
          if (state.status == AuthStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('We\'ve resend email one more time')));
          } else if (state.status == AuthStatus.toManyRequests) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('To many requests. Please try again later')));
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Something goes wrong during sending message')));
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
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset(
                      'assets/images/send-mail.png',
                      scale: 5,
                    )),
                const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'We`ve sent a verification email to:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                Text(
                  email,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                            style: TextStyle(color: Colors.black),
                            text:
                                'Click the link in your email to verify your account. \nIf you cant find the email check your spam folder or\n'),
                        TextSpan(
                            style: TextStyle(
                                color: Colors.deepPurple.shade400,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            text: 'click here to resend.',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context
                                  .read<AuthCubit>()
                                  .sendVerificationEmail(true)),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'After verifying your email',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () => context.go('/EmailAuthScreen'),
                      child:
                          const Text('Log in', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
