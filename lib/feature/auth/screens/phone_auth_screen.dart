import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/feature/home/cubits/home/home_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/feature/auth/screens/widgets/phone_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';
import 'package:chats/app_constants.dart';

class PhoneAuthScreen extends StatelessWidget {
  PhoneAuthScreen({super.key});

  final _phoneInputController = TextEditingController();

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
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          state.status == AuthStatus.codeSent ||
                                  state.status == AuthStatus.submitting
                              ? 'Enter verification code'
                              : 'Enter your phone number',
                          style: const TextStyle(fontSize: 16),
                        ))),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: PhoneTextInput(
                        controller: _phoneInputController,
                        labelText: state.status == AuthStatus.codeSent ||
                                state.status == AuthStatus.submitting
                            ? 'Verification code'
                            : 'Phone number',
                        prefixText:
                            state.status == AuthStatus.codeSent ? null : '+380',
                        phoneValidator: state.status == AuthStatus.initial
                            ? Validator.phoneValidator
                            : (_) => null,
                        onChanged: state.status == AuthStatus.codeSent
                            ? (value) => context
                                .read<AuthCubit>()
                                .verificationCodeChanged(value)
                            : (value) =>
                                context.read<AuthCubit>().phoneChanged(value))),
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
                        onPressed: state.status == AuthStatus.codeSent
                            ? context.read<AuthCubit>().isSmsCodeValid
                                ? () => context
                                    .read<AuthCubit>()
                                    .loginWithSMSCode(
                                        smsCode: _phoneInputController.text)
                                : null
                            : context.read<AuthCubit>().isPhoneValid
                                ? () => context.read<AuthCubit>().sendSMS()
                                : null,
                        child: state.status == AuthStatus.submitting
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : state.status == AuthStatus.codeSent
                                ? const Text('Submit',
                                    style: TextStyle(fontSize: 20))
                                : const Text('Send SMS',
                                    style: TextStyle(fontSize: 20)))),
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
    if (state.status == AuthStatus.submitting) {
      _phoneInputController.clear();
    } else if (state.status == AuthStatus.success) {
      context
          .read<HomeCubit>()
          .addUserIfNotExists(provider: state.provider!, user: state.user!);
      context.go('/');
    } else if (state.status == AuthStatus.error) {
      Flushbar(message: state.errorText, flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    }
  }
}
