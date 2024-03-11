import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;

class AlternativeSignInMethods extends StatelessWidget {
  final void Function() onPhonePressed;
  final void Function() onGooglePressed;
  final void Function() onFacebookPressed;

  const AlternativeSignInMethods(
      {super.key,
      required this.onPhonePressed,
      required this.onGooglePressed,
      required this.onFacebookPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(5),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
            onPressed: onPhonePressed,
            icon: Icon(Icons.phone, size: 20, color: Colors.grey.shade500),
            label: const Text(
              'Phone',
              style: TextStyle(color: constants.textButtonColor),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(5),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
            onPressed: onGooglePressed,
            icon: Image.asset(
              'assets/images/google.png',
              scale: 5,
            ),
            label: const Text(
              'Google',
              style: TextStyle(color: constants.textButtonColor),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(5),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
            onPressed: onFacebookPressed,
            icon: Image.asset(
              'assets/images/facebook.png',
              scale: 4,
            ),
            label: const Text(
              'Facebook',
              style: TextStyle(color: constants.textButtonColor),
            ),
          ),
        ),
        const SizedBox(width: 20)
      ],
    );
  }
}
