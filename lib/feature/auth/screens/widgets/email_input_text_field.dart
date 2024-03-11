import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;

class EmailTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?) emailValidator;
  final void Function(String) onChanged;
  const EmailTextInput(
      {required this.controller,
      required this.labelText,
      required this.emailValidator,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: constants.textFormFieldColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        minLines: 1,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        onChanged: onChanged,
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
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
