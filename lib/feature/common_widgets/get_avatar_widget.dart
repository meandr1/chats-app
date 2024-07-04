import 'dart:io' show File;
import 'package:chats/app_constants.dart';
import 'package:flutter/material.dart';

Widget getAvatarWidget(
    {required AsyncSnapshot<File?> snapshot,
    required String? photoUrl,
    required double diameter,
    required IconData noAvatarIcon}) {
  DecorationImage? image;
  Icon? icon;

  if (photoUrl == '') {
    icon = Icon(
      size: diameter,
      noAvatarIcon,
      color: AppConstants.iconsColor,
    );
  } else if (snapshot.hasError || snapshot.data == null) {
    image = const DecorationImage(
      image: AssetImage(AppConstants.failedToLoadImageAsset),
      fit: BoxFit.cover,
    );
  } else if (snapshot.hasData) {
    image = DecorationImage(
      image: FileImage(snapshot.data!),
      fit: BoxFit.cover,
    );
  } else {
    return const CircularProgressIndicator();
  }

  return Container(
    width: diameter,
    height: diameter,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: image,
    ),
    child: icon,
  );
}
