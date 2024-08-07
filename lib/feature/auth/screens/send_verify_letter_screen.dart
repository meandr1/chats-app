import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';
import 'package:chats/app_constants.dart';

class SendVerifyLetterScreen extends StatelessWidget {
  final String email;
  const SendVerifyLetterScreen({required this.email, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        listener: statusListener,
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: MainLogo(text: 'Welcome to Chats'),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset(
                      AppConstants.sendEmailAsset,
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
                  email.toLowerCase(),
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
                            text: AppConstants.verifyEmailText),
                        TextSpan(
                            style: const TextStyle(
                                color: AppConstants.textButtonColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            text: AppConstants.verifyEmailClickableText,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context
                                  .read<AuthCubit>()
                                  .sendVerificationEmail(isResend: true)),
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
                      style: TextButton.styleFrom(
                          foregroundColor: AppConstants.textButtonColor),
                      onPressed: () => context.go('/EmailAuthScreen'),
                      child:
                          const Text('Log in', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void statusListener(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.emailWasSend) {
      Flushbar(
              message: AppConstants.onResendVerifyLetter,
              flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    } else if (state.status == AuthStatus.error) {
      Flushbar(message: state.errorText, flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    }
  }
}
