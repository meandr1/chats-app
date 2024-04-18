import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/feature/home/cubits/home/home_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/feature/auth/screens/widgets/alternative_sign_in_methods.dart';
import 'package:chats/feature/auth/screens/widgets/email_input_text_field.dart';
import 'package:chats/feature/auth/screens/widgets/pass_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';
import 'package:chats/app_constants.dart' as constants;

class EmailAuthScreen extends StatelessWidget {
  EmailAuthScreen({super.key});

  final _emailInputController = TextEditingController();
  final _passInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        listener: statusListener,
        builder: (context, state) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor:
                  Theme.of(context).scaffoldBackgroundColor));
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
                          'Sign in to your account',
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
                        const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: PassTextInput(
                      controller: _passInputController,
                      labelText: 'Password',
                      showIcon: true,
                      textInputAction: TextInputAction.done,
                      validator: Validator.passValidator,
                      obscurePassword: state.obscurePassword,
                      onChanged: (value) =>
                          context.read<AuthCubit>().passwordChanged(value),
                      onIconPressed: () => context
                          .read<AuthCubit>()
                          .changeObscurePasswordStatus(state.obscurePassword),
                      onEditingComplete:
                          context.read<AuthCubit>().isSignFormsValid
                              ? () => context
                                  .read<AuthCubit>()
                                  .signInWithEmailAndPassword()
                              : null,
                    )),
                Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: constants.textButtonColor),
                          onPressed: () => context.go('/ForgotPassScreen'),
                          child: const Text('Forgot Password?',
                              style: TextStyle(fontSize: 16)),
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
                      onPressed: context.read<AuthCubit>().isSignFormsValid
                          ? () => context
                              .read<AuthCubit>()
                              .signInWithEmailAndPassword()
                          : null,
                      child: state.status == AuthStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Login', style: TextStyle(fontSize: 20)),
                    )),
                const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 18),
                    child: LoginDivider()),
                Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AlternativeSignInMethods(
                      onPhonePressed: () => context.go('/PhoneAuthScreen'),
                      onGooglePressed: () =>
                          context.read<AuthCubit>().signInWithGoogle(),
                      onFacebookPressed: () =>
                          context.read<AuthCubit>().signInWithFacebook(),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don`t have an account?',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: constants.textButtonColor),
                      onPressed: () => context.go('/RegisterScreen'),
                      child: const Text('Register',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void statusListener(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.success) {
      if (state.user!.emailVerified ||
          state.provider == constants.facebookProvider) {
        context.read<HomeCubit>().addUserIfNotExists(
            provider: state.provider!, uid: state.user!.uid);
        context.go('/');
      } else {
        context.read<AuthCubit>().sendVerificationEmail(isResend: false);
        context.go('/SendVerifyLetterScreen/${state.email}');
      }
    } else if (state.status == AuthStatus.error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.errorText)));
    }
  }
}

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade400)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Or login with'),
        ),
        Expanded(child: Divider(color: Colors.grey.shade400)),
      ],
    );
  }
}
