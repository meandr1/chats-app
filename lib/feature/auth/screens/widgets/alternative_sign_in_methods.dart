import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';

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
    return SizedBox(
      height: AppConstants.defaultButtonHigh,
      child: Row(
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
              label: const AutoSizeText(
                'Phone',
                maxLines: 1,
                style: TextStyle(color: AppConstants.textButtonColor),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              onPressed: onGooglePressed,
              icon: Image.asset(
                AppConstants.googleLogoAsset,
                scale: 5,
              ),
              label: const AutoSizeText(
                'Google',
                maxLines: 1,
                style: TextStyle(color: AppConstants.textButtonColor),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)))),
              onPressed: onFacebookPressed,
              icon: Image.asset(
                AppConstants.facebookLogoAsset,
                scale: 4,
              ),
              label: const AutoSizeText(
                'Facebook',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppConstants.textButtonColor),
              ),
            ),
          ),
          const SizedBox(width: 20)
        ],
      ),
    );
  }
}
