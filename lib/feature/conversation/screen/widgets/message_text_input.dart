import 'package:chats/feature/conversation/cubit/conversation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageTextInput extends StatelessWidget {
  final TextEditingController controller;
  const MessageTextInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 100),
        child: TextFormField(
          onChanged: (text) =>
              context.read<ConversationCubit>().messageTyping(text),
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)),
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
      ),
    );
  }
}