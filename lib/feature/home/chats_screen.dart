import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;

class ChatsWidget extends StatelessWidget {
  final void Function() onPressed;
  const ChatsWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Expanded(child: SizedBox.shrink()),
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
              onPressed: onPressed,
              child: const Icon(size: 40, Icons.add),
            )),
      ),
    ]);
  }
}
