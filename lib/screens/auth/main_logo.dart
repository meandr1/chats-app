import 'package:flutter/material.dart';

class MainLogo extends StatelessWidget {
  const MainLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: const Text(
              'Welcome to Chats',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            )),
        Image.asset('assets/images/chat_icon.png', scale: 9)
      ],
    );
  }
}
