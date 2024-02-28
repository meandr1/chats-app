import 'package:chats/cubits/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool showIcon;
  final TextInputAction textInputAction;
  final String? Function(String?) validator;
  const PassTextInput({required this.controller, required this.labelText, required this.showIcon, required this.textInputAction, required this.validator, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          obscureText: state.obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: textInputAction,
          autofocus: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          onChanged: (value) =>
              context.read<AuthCubit>().passwordChanged(value),
          decoration: InputDecoration(
            helperText: ' ',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: showIcon
                ? IconButton(
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
                  )
                : null,
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
