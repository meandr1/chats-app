import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';

class PassTextInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool autofocus;
  bool obscureText;

  PassTextInput(this.controller, this.labelText,
      {this.autofocus = false, this.obscureText = true, super.key});

  @override
  State<PassTextInput> createState() => _PassTextInputState();
}

class _PassTextInputState extends State<PassTextInput> with Validator {
  ValueNotifier<bool> passHide = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return ValueListenableBuilder(
        valueListenable: passHide,
        builder: (context, obscureText, _) {
          return Form(
              key: _formKey,
              child: TextFormField(
                controller: widget.controller,
                obscureText: obscureText,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autofocus: widget.autofocus,
                onChanged: (_) => _formKey.currentState?.validate(),
                validator: passValidator,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: widget.labelText,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: IconButton(
                    onPressed: () => passHide.value = !obscureText,
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
              ));
        });
  }
}
