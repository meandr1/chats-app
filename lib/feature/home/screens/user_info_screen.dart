import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;
import '../../../model/firebase_user.dart';

class UserInfoScreen extends StatelessWidget {
  final void Function() onSignOut;
  final void Function()? onSave;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final void Function(String) onFirstNameChanged;
  final void Function(String) onLastNameChanged;
  final void Function(String) onEmailChanged;
  final void Function(String) onPhoneChanged;
  final UserInfo? userInfo;
  const UserInfoScreen(
      {super.key,
      required this.userInfo,
      required this.onSignOut,
      required this.onSave,
      required this.firstNameController,
      required this.lastNameController,
      required this.emailController,
      required this.phoneController,
      required this.onEmailChanged,
      required this.onPhoneChanged,
      required this.onFirstNameChanged,
      required this.onLastNameChanged});

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
                                      fit: BoxFit.cover))),
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
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'This field can\'t be empty'
                      : null;
                },
                enabled: true,
                controller: firstNameController,
                labelText: 'FIRST NAME',
                onChanged: onFirstNameChanged,
                icon: const Icon(Icons.person, color: constants.iconsColor)),
            UserInfoTextInput(
                validator: (value) {
                  return value == null || value.isEmpty
                      ? 'This field can\'t be empty'
                      : null;
                },
                enabled: true,
                controller: lastNameController,
                labelText: 'LAST NAME',
                onChanged: onLastNameChanged,
                icon: const Icon(Icons.person, color: constants.iconsColor)),
            UserInfoTextInput(
                validator: Validator.emailValidator,
                enabled: userInfo?.email == '',
                controller: emailController,
                labelText: 'EMAIL',
                onChanged: onEmailChanged,
                icon: const Icon(Icons.alternate_email,
                    color: constants.iconsColor)),
            UserInfoTextInput(
                prefixText: userInfo?.phoneNumber == '' ? '+380' : null,
                validator: Validator.phoneValidator,
                enabled: userInfo?.phoneNumber == '',
                controller: phoneController,
                labelText: 'PHONE NUMBER',
                onChanged: onPhoneChanged,
                icon: const Icon(Icons.phone, color: constants.iconsColor)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 0),
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
  final String? prefixText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  const UserInfoTextInput(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.icon,
      required this.enabled,
      this.onChanged,
      this.validator,
      this.prefixText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Theme(
          data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: constants.textFormFieldColor)),
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            onChanged: onChanged,
            validator: validator,
            autovalidateMode:
                validator != null ? AutovalidateMode.onUserInteraction : null,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 48, top: 5, bottom: 1),
                errorStyle: const TextStyle(height: 0.2),
                helperStyle: const TextStyle(height: 0.2),
                helperText: ' ',
                prefixText: prefixText,
                border: InputBorder.none,
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: icon),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            style: const TextStyle(fontWeight: FontWeight.w500),
          )),
    );
  }
}
