import 'package:chats/feature/home/screens/widgets/get_chats_list.dart';
import 'package:chats/model/firebase_user.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;

class ChatsScreen extends StatelessWidget {
  final void Function() onChatAdd;
  final void Function(String uid) onChatTap;
  final List<Conversation>? conversations;
  const ChatsScreen(
      {super.key, required this.onChatAdd, required this.conversations, required this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child: ChatsList(onChatTap: onChatTap, conversations: conversations)),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 15, right: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: constants.elevatedButtonColor,
                  foregroundColor: Colors.white,
                  elevation: 10,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10)),
              onPressed: onChatAdd,
              child: const Icon(size: constants.defaultButtonHigh, Icons.add),
            )),
      ),
    ]);
  }
}
