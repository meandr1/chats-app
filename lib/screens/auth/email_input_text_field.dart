import 'package:flutter/material.dart';

class EmailTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool autofocus;
  EmailTextInput(this.controller, this.labelText,
      {this.autofocus = false, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      onChanged: (_) {},
      keyboardType: TextInputType.emailAddress,
      autofocus: autofocus,
      validator: (_) {},
      decoration: InputDecoration(
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
  }
}
