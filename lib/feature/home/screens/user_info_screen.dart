import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;
import '../../../model/firebase_user.dart';

class UserInfoScreen extends StatelessWidget {
  final void Function() onSignOut;
  final void Function() onSave;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final UserInfo? userInfo;
  const UserInfoScreen(
      {super.key,
      required this.userInfo,
      required this.onSignOut,
      required this.onSave,
      required this.firstNameController,
      required this.lastNameController,
      required this.emailController,
      required this.phoneController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
      child: Column(children: <Widget>[
        Expanded(
          child: ListView(children: [
            Stack(children: [
              Center(
                  child: userInfo?.photoURL != null
                      ? CachedNetworkImage(
                          imageUrl: userInfo!.photoURL!,
                          imageBuilder: (context, imageProvider) => Container(
                              width: constants.imageDiameterLarge,
                              height: constants.imageDiameterLarge,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.contain))),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/broken_image.png'))
                      : const Icon(
                          size: constants.imageDiameterLarge,
                          constants.defaultPersonIcon,
                          color: constants.iconsColor,
                        )),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    onPressed: onSignOut,
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: constants.iconsColor,
                    )),
              )
            ]),
            const Divider(),
            UserInfoTextInput(
                enabled: true,
                controller: firstNameController
                  ..text = userInfo?.firstName ?? '',
                labelText: 'FIRST NAME',
                onChanged: (_) {},
                icon: const Icon(Icons.person, color: constants.iconsColor)),
            UserInfoTextInput(
                enabled: true,
                controller: lastNameController..text = userInfo?.lastName ?? '',
                labelText: 'LAST NAME',
                onChanged: (_) {},
                icon: const Icon(Icons.person, color: constants.iconsColor)),
            UserInfoTextInput(
                enabled: userInfo?.email == null,
                controller: emailController..text = userInfo?.email ?? '',
                labelText: 'EMAIL',
                onChanged: (_) {},
                icon: const Icon(Icons.alternate_email,
                    color: constants.iconsColor)),
            UserInfoTextInput(
                enabled: userInfo?.phoneNumber == null,
                controller: phoneController..text = userInfo?.phoneNumber ?? '',
                labelText: 'PHONE NUMBER',
                onChanged: (_) {},
                icon: const Icon(Icons.phone, color: constants.iconsColor)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: constants.elevatedButtonColor,
                foregroundColor: Colors.white,
                minimumSize:
                    const Size(double.infinity, constants.defaultButtonHigh),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
            onPressed: onSave,
            child: const Text('Save changes', style: TextStyle(fontSize: 20)),
          ),
        ),
      ]),
    );
  }
}

class UserInfoTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Widget icon;
  final bool enabled;
  final void Function(String) onChanged;
  const UserInfoTextInput(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.onChanged,
      required this.icon,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: constants.textFormFieldColor,
          ),
        ),
        child: TextFormField(
          enabled: enabled,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              border: InputBorder.none,
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              prefixIcon: icon),
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ));
  }
}
