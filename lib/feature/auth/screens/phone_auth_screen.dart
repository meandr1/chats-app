import 'package:chats/feature/auth/cubit/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/feature/auth/repository/auth_repository.dart';
import 'package:chats/feature/auth/screens/widgets/phone_input_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'widgets/main_logo.dart';
import 'package:chats/app_constants.dart' as constants;

class PhoneAuthScreen extends StatelessWidget {
  PhoneAuthScreen({super.key});

  final _phoneInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (context) =>
            AuthCubit(AuthRepository()),
        child: BlocConsumer<AuthCubit, AuthState>(
            listener: (BuildContext context, AuthState state) {
          if (state.status == AuthStatus.submitting) {
            _phoneInputController.clear();
          } else if (state.status == AuthStatus.success) {
            context.go('/');
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
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          state.status == AuthStatus.initial
                              ? 'Enter your phone number'
                              : 'Enter verification code',
                          style: const TextStyle(fontSize: 16),
                        ))),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: PhoneTextInput(
                      controller: _phoneInputController,
                      labelText: state.status == AuthStatus.initial
                          ? 'Phone number'
                          : 'Verification code',
                      prefixText:
                          state.status == AuthStatus.initial ? '+380' : null,
                      phoneValidator: state.status == AuthStatus.initial
                          ? Validator.phoneValidator
                          : (_) => null,
                      onChanged: state.status == AuthStatus.initial
                          ? (value) =>
                              context.read<AuthCubit>().phoneChanged(value)
                          : (_) {},
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
                      onPressed: state.status == AuthStatus.codeSent
                          ? () => context.read<AuthCubit>().loginWithSMSCode(
                              smsCode: _phoneInputController.text)
                          : context.read<AuthCubit>().isPhoneValid
                              ? () => context.read<AuthCubit>().sendSMS()
                              : null,
                      child: state.status == AuthStatus.submitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : state.status == AuthStatus.initial
                              ? const Text('Send SMS',
                                  style: TextStyle(fontSize: 20))
                              : const Text('Submit',
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
