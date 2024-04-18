import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/cubits/find_users/find_users_cubit.dart';
import 'package:chats/feature/home/screens/widgets/get_users_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chats/app_constants.dart' as constants;
import 'package:flutter_bloc/flutter_bloc.dart';

class FindUsersScreen extends StatelessWidget {
  final TextEditingController searchUsersInputController =
      TextEditingController();
  final void Function() onBackButtonPress;
  final void Function(
      {required String companionUID,
      required String companionName,
      required String companionPhotoURL}) onUserTap;

  FindUsersScreen({
    super.key,
    required this.onBackButtonPress,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FindUsersCubit, FindUsersState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
                systemNavigationBarColor:
                    Theme.of(context).scaffoldBackgroundColor),
            leading: BackButton(onPressed: onBackButtonPress),
            backgroundColor: constants.appBarColor,
            title: const SizedBox(
              height: constants.mainLogoSmallSize,
              child: MainLogo(),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SearchUsersTextInput(
                    controller: searchUsersInputController,
                    labelText: 'Filter:',
                    onChanged: (pattern) =>
                        context.read<FindUsersCubit>().filterUsers(pattern)),
              ),
              Expanded(
                  child: state.status == FindUsersStatus.initial
                      ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator())
                      : state.status == FindUsersStatus.success
                          ? UsersList(
                              users: state.filteredUsers, onTap: onUserTap)
                          : const Icon(Icons.error)),
            ],
          ));
    });
  }
}

class SearchUsersTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String) onChanged;
  const SearchUsersTextInput(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: constants.textFormFieldColor,
        ),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: const Icon(Icons.person, color: constants.iconsColor)),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
