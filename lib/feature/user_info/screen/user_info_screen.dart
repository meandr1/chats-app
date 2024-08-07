import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/chats/cubit/chats_cubit.dart';
import 'package:chats/feature/common_widgets/get_avatar_widget.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/user_info/cubit/user_info_cubit.dart';
import 'package:chats/helpers/validator.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserInfoScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserInfoCubit, UserInfoState>(
      listener: statusListener,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
          child: Column(children: [
            Expanded(
              child: ListView(children: [
                Stack(children: [
                  GestureDetector(
                    onTap: () => context
                        .read<UserInfoCubit>()
                        .addPhoto(currentUID: state.currentUser!.uid),
                    child: FutureBuilder(
                        future: context
                            .read<HomeCubit>()
                            .getFile(state.currentUser?.userInfo.photoURL),
                        builder: (_, snapshot) => Center(
                            child: getAvatarWidget(
                                noAvatarIcon: AppConstants.addPhotoIcon,
                                snapshot: snapshot,
                                photoUrl: state.currentUser?.userInfo.photoURL,
                                diameter: AppConstants.imageDiameterLarge))),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          context.read<ChatsCubit>().clearStateConversations();
                          context.read<UserInfoCubit>().signOut();
                          context.go('/EmailAuthScreen');
                        },
                        icon: const Icon(
                          Icons.logout_outlined,
                          color: AppConstants.iconsColor,
                        )),
                  )
                ]),
                const Divider(),
                UserInfoTextInput(
                    validator: Validator.emptyFieldValidator,
                    enabled: true,
                    controller: firstNameController
                      ..text = state.firstName ?? '',
                    labelText: 'FIRST NAME',
                    onChanged: (value) =>
                        context.read<UserInfoCubit>().firstNameChanged(value),
                    icon: const Icon(Icons.person,
                        color: AppConstants.iconsColor)),
                UserInfoTextInput(
                    validator: Validator.emptyFieldValidator,
                    enabled: true,
                    controller: lastNameController..text = state.lastName ?? '',
                    labelText: 'LAST NAME',
                    onChanged: (value) =>
                        context.read<UserInfoCubit>().lastNameChanged(value),
                    icon: const Icon(Icons.person,
                        color: AppConstants.iconsColor)),
                UserInfoTextInput(
                    validator: Validator.emailValidator,
                    enabled: state.currentUser?.userInfo.provider == 'phone',
                    controller: emailController..text = state.email ?? '',
                    labelText: 'EMAIL',
                    onChanged: (value) =>
                        context.read<UserInfoCubit>().emailChanged(value),
                    icon: const Icon(Icons.alternate_email,
                        color: AppConstants.iconsColor)),
                UserInfoTextInput(
                    prefixText: '+380',
                    validator: Validator.phoneValidator,
                    enabled: state.currentUser?.userInfo.provider != 'phone',
                    controller: phoneController..text = state.phoneNumber ?? '',
                    labelText: 'PHONE NUMBER',
                    onChanged: (value) =>
                        context.read<UserInfoCubit>().phoneChanged(value),
                    icon: const Icon(Icons.phone,
                        color: AppConstants.iconsColor)),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.elevatedButtonColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(
                        double.infinity, AppConstants.defaultButtonHigh),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                onPressed: context.read<UserInfoCubit>().isProfileDataChanged &&
                        context.read<UserInfoCubit>().isFormsValid
                    ? () => context.read<UserInfoCubit>().updateUserInfo(
                        currentUID: state.currentUser!.uid,
                        newFirstName: firstNameController.text,
                        newLastName: lastNameController.text,
                        newEmail: emailController.text,
                        newPhoneNumber: phoneController.text)
                    : null,
                child: state.status == UserInfoStatus.submitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save changes',
                        style: TextStyle(fontSize: 20)),
              ),
            ),
          ]),
        );
      },
    );
  }

  void statusListener(BuildContext context, UserInfoState state) {
    if (state.status == UserInfoStatus.updated) {
      context.read<HomeCubit>().getCurrentUserInfo();
    } else if (state.status == UserInfoStatus.permissionNotGranted) {
      Flushbar(
              message: AppConstants.onGalleryPermissionNotGranted,
              flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    } else if (state.status == UserInfoStatus.error) {
      Flushbar(
              message: AppConstants.onGalleryPermissionNotGranted,
              flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    }
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
    return SizedBox(
      height: 70,
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        autovalidateMode:
            validator != null ? AutovalidateMode.onUserInteraction : null,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 48, top: 5),
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
      ),
    );
  }
}
