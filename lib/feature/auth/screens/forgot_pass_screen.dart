import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/feature/auth/screens/widgets/email_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';
import 'package:chats/app_constants.dart';

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});

  final _emailInputController = TextEditingController();

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
                    child: EmailTextInput(
                      controller: _emailInputController,
                      labelText: 'Email',
                      emailValidator: Validator.emailValidator,
                      onChanged: (value) =>
                          context.read<AuthCubit>().emailChanged(value),
                    )),
                Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.elevatedButtonColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(
                              double.infinity, AppConstants.defaultButtonHigh),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onPressed: context.read<AuthCubit>().isEmailValid
                          ? () => context
                              .read<AuthCubit>()
                              .sendPasswordResetEmail(email: state.email)
                          : null,
                      child: state.status == AuthStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Reset password',
                              style: TextStyle(fontSize: 20)),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: AppConstants.textButtonColor),
                          onPressed: () => context.go('/EmailAuthScreen'),
                          child: const Text('Back to login',
                              style: TextStyle(fontSize: 16)),
                        ))),
              ],
            ),
          );
        });
  }

  void statusListener(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.emailWasSend) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Flushbar(
          message: AppConstants.onPassResetLinkSend,
          flushbarPosition: FlushbarPosition.TOP,
          duration: const Duration(seconds: 3),
        ).show(context);
      });
      context.go('/EmailAuthScreen');
    } else if (state.status == AuthStatus.error) {
      Flushbar(message: state.errorText, flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    }
  }
}
