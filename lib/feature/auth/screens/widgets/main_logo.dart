import 'package:flutter/material.dart';

class MainLogo extends StatelessWidget {
  final String text;
  const MainLogo({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 130),
            child: Text(
              text,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            )),
        Image.asset('assets/images/chat_icon.png', scale: 9)
      ],
    );
  }
}
