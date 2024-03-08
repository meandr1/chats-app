import 'package:flutter/material.dart';

class PassTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool showIcon;
  final TextInputAction textInputAction;
  final String? Function(String?) validator;
  final void Function(String) onChanged;
  final bool obscurePassword;
  final void Function() onIconPressed;
  const PassTextInput(
      {required this.controller,
      required this.labelText,
      required this.showIcon,
      required this.textInputAction,
      required this.validator,
      required this.onChanged,
      required this.obscurePassword,
      required this.onIconPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: textInputAction,
      autofocus: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        helperText: ' ',
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: showIcon
            ? Focus(
                canRequestFocus: false,
                descendantsAreFocusable: false,
                child: IconButton(
                  onPressed: onIconPressed,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                ))
            : null,
      ),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      style: const TextStyle(fontWeight: FontWeight.w500),
    );
  }
}
