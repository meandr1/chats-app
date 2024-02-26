import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailTextInput extends StatelessWidget with Validator {
  final TextEditingController controller;
  final String labelText;
  const EmailTextInput(this.controller, this.labelText,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return  TextFormField(
          controller: controller,
          textInputAction: TextInputAction.next,
          minLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          validator: emailValidator,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            helperText: ' ',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        );
      },
    );
  }
}
