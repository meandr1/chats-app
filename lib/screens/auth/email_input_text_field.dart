import 'package:flutter/material.dart';

class EmailTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool autofocus;
  ValueNotifier<bool> isEmailValid = ValueNotifier(false);
  EmailTextInput(this.controller, this.labelText,
      {this.autofocus = false, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isEmailValid,
        builder: (context, obscureText, _) {
         return TextFormField(
            controller: controller,
            textInputAction: TextInputAction.next,
            // onChanged: ,
            keyboardType: TextInputType.emailAddress,
            autofocus: autofocus,
            validator: (_) {print ('fgfgfkjhfkjhgkfjhgkjbfkjgbkfjbhgkjfb');return 'xcxcxcxcxc';},
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          );
        });
  }
}
