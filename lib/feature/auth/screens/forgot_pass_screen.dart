import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/feature/auth/repository/auth_repository.dart';
import 'package:chats/feature/auth/screens/widgets/email_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'widgets/main_logo.dart';
import 'package:chats/app_constants.dart' as constants;

class ForgotPassScreen extends StatelessWidget {
  ForgotPassScreen({super.key});

  final _emailInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(AuthRepository()),
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (BuildContext context, AuthState state) {
          if (state.status == AuthStatus.success) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.info(
                message: "Password reset link was send. Check your email.",
              ),
            );
            context.go('/EmailAuthScreen');
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorText)));
          }
        }, builder: (context, state) {
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
                          backgroundColor:
                              constants.elevatedButtonColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
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
                              foregroundColor: constants.textButtonColor),
                          onPressed: () => context.go('/EmailAuthScreen'),
                          child: const Text('Back to login',
                              style: TextStyle(fontSize: 16)),
                        ))),
              ],
            ),
          );
        }));
  }
}
