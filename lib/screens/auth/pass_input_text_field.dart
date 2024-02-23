import 'package:chats/bloc/cubit/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassTextInput extends StatelessWidget with Validator {
  final TextEditingController controller;
  final String labelText;
  final bool autofocus;
  PassTextInput(this.controller, this.labelText,
      {this.autofocus = false, super.key});

  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          autofocus: autofocus,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: passValidator,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric (vertical: 8.0, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: labelText,

            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: IconButton(
              onPressed: () {
                obscureText = !obscureText;
                context.read<AuthCubit>().changeObscureStatus();
              },
              icon: Icon(
                obscureText
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