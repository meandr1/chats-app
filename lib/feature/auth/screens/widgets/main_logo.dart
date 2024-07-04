import 'package:chats/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainLogo extends StatelessWidget {
  final String? text;
  const MainLogo({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Text(
          text ?? 'Chats',
          style: const TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        )),
        Image.asset(AppConstants.chatsAppLogoAsset, scale: 9)
      ],
    );
  }
}
