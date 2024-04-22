import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/feature/auth/screens/widgets/email_input_text_field.dart';
import 'package:chats/feature/auth/screens/widgets/pass_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';
import 'package:chats/app_constants.dart' as constants;

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailInputController = TextEditingController();
  final _passInputController = TextEditingController();
  final _passRepeatInputController = TextEditingController();

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
                          'Register a new account',
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
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 15),
                    child: PassTextInput(
                      controller: _passInputController,
                      labelText: 'Password',
                      showIcon: true,
                      textInputAction: TextInputAction.next,
                      validator: Validator.passValidator,
                      onChanged: (value) =>
                          context.read<AuthCubit>().passwordChanged(value),
                      obscurePassword: state.obscurePassword,
                      onIconPressed: () => context
                          .read<AuthCubit>()
                          .changeObscurePasswordStatus(state.obscurePassword),
                      onEditingComplete: state.obscurePassword
                          ? null
                          : context.read<AuthCubit>().isRegisterFormsValid
                              ? () => context
                                  .read<AuthCubit>()
                                  .registerWithEmailAndPassword()
                              : null,
                    )),
                Visibility(
                    visible: state.obscurePassword,
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 15),
                        child: PassTextInput(
                          controller: _passRepeatInputController,
                          labelText: 'Repeat password',
                          showIcon: false,
                          textInputAction: TextInputAction.done,
                          validator: (repeatPassword) =>
                              _passInputController.text == repeatPassword
                                  ? null
                                  : 'Password didn`t match',
                          onChanged: (value) => context
                              .read<AuthCubit>()
                              .repeatPasswordChanged(value),
                          obscurePassword: state.obscurePassword,
                          onIconPressed: () => context
                              .read<AuthCubit>()
                              .changeObscurePasswordStatus(
                                  state.obscurePassword),
                          onEditingComplete:
                              context.read<AuthCubit>().isRegisterFormsValid
                                  ? () => context
                                      .read<AuthCubit>()
                                      .registerWithEmailAndPassword()
                                  : null,
                        ))),
                Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: constants.elevatedButtonColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(
                              double.infinity, constants.defaultButtonHigh),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)))),
                      onPressed: context.read<AuthCubit>().isRegisterFormsValid
                          ? () => context
                              .read<AuthCubit>()
                              .registerWithEmailAndPassword()
                          : null,
                      child: state.status == AuthStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Register',
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
                      style: TextButton.styleFrom(
                          foregroundColor: constants.textButtonColor),
                      onPressed: () => context.go('/EmailAuthScreen'),
                      child:
                          const Text('Login', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void statusListener(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.registered) {
      context.read<AuthCubit>().sendVerificationEmail(isResend: false);
      context.go('/SendVerifyLetterScreen/${state.email}');
    } else if (state.status == AuthStatus.error) {
      Flushbar(message: state.errorText, flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    }
  }
}
