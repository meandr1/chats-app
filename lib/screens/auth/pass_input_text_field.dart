import 'package:chats/bloc/cubit/auth_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassTextInput extends StatelessWidget with Validator {
  final TextEditingController controller;
  final String labelText;
  final bool autofocus;
  bool obscureText;

  PassTextInput(this.controller, this.labelText,
      {this.autofocus = false, this.obscureText = true, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
        create: (context) => AuthCubit(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofocus: autofocus,
              onChanged: (pass) => context.read<AuthCubit>().validatePass(pass),
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                labelText: labelText,
                // errorText: ,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: IconButton(
                  onPressed: () => context
                      .read<AuthCubit>()
                      .changeObscureStatus(obscureText = !obscureText),
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
        ));
  }
}

/*

Мы описываем два состояния: ошибка и успех (можно три - загрузка)
Но в ошибочном состоянии мы задаем несколько параметров: ошибка емейла, ошибка пароля и т.д.

мы эмитим просто стейт ошибки а в зависимоти от этих параметров привильно отображаем ошибки.
Проще передавать из стейта текст ошибки.


*/