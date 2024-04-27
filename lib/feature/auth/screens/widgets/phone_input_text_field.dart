import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';

class PhoneTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? prefixText;
  final String? Function(String?) phoneValidator;
  final void Function(String?) onChanged;
  const PhoneTextInput(
      {required this.controller,
      required this.labelText,
      required this.prefixText,
      required this.phoneValidator,
      required this.onChanged,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.textFormFieldColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.done,
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: phoneValidator,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixText: prefixText,
          helperText: ' ',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
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
