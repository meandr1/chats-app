import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassTextInput extends StatelessWidget with Validator {
  final TextEditingController controller;
  final String labelText;
  PassTextInput(this.controller, this.labelText, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          obscureText: state.obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autofocus: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: passValidator,
          onChanged: (value) =>
              context.read<AuthCubit>().passwordChanged(value),
          decoration: InputDecoration(
            helperText: ' ',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              onPressed: () {
                context
                    .read<AuthCubit>()
                    .changeObscurePasswordStatus(state.obscurePassword);
              },
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.black,
              ),
            ),
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


/*

Мы описываем два состояния: ошибка и успех (можно три - загрузка)
Но в ошибочном состоянии мы задаем несколько параметров: ошибка емейла, ошибка пароля и т.д.

мы эмитим просто стейт ошибки а в зависимоти от этих параметров привильно отображаем ошибки.
Проще передавать из стейта текст ошибки.

*/