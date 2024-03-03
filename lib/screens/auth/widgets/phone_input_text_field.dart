import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneTextInput extends StatelessWidget with Validator {
  final TextEditingController controller;
  final String labelText;
  final bool isVerification;
  const PhoneTextInput(
      {required this.controller,
      required this.labelText,
      required this.isVerification,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator:
              state.status == AuthStatus.initial ? phoneValidator : (_) => null,
          onChanged: state.status == AuthStatus.initial
              ? (value) => context.read<AuthCubit>().phoneChanged(value)
              : (_) {},
          decoration: InputDecoration(
            prefixText: isVerification ? '+380' : null,
            helperText: ' ',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        );
      },
    );
  }
}
