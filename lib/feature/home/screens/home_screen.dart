import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/screens/chats_screen.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/feature/home/screens/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chats/app_constants.dart' as constants;

class HomeScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(HomeRepository())..getCurrentUserInfo(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStatus.fillProfileNeeded &&
              state.isFillUserInfoFlushBarWasShown == null) {
            Flushbar(
              message: constants.onFillUserInfo,
              flushbarPosition: FlushbarPosition.TOP,
              duration: const Duration(seconds: 4),
            ).show(context);
          }
        },
        builder: (context, state) {
          return MaterialApp(
            home: DefaultTabController(
                length: 3,
                child: Builder(builder: (context) {
                  TabController tabController =
                      DefaultTabController.of(context);
                  if (state.status == HomeStatus.fillProfileNeeded) {
                    tabController.animateTo(2);
                  }
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: constants.appBarColor,
                      title: const SizedBox(
                        height: 80,
                        child: MainLogo(),
                      ),
                    ),
                    bottomNavigationBar: Container(
                        color: constants.bottomNavigationBarColor,
                        child: SafeArea(
                            child: IgnorePointer(
                                ignoring: state.status ==
                                    HomeStatus.fillProfileNeeded,
                                child: const TabBar(
                                    dividerHeight: 0,
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white54,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    indicatorPadding: EdgeInsets.all(5.0),
                                    indicatorColor: Colors.white,
                                    tabs: [
                                      Tab(
                                          icon: Icon(
                                              size: 35,
                                              Icons.messenger_outlined)),
                                      Tab(
                                          icon: Icon(
                                              size: 35, Icons.location_on)),
                                      Tab(
                                          icon: Icon(
                                              size: 35,
                                              constants.defaultPersonIcon)),
                                    ])))),
                    body: state.status == HomeStatus.initial
                        ? const Center(child: CircularProgressIndicator())
                        : TabBarView(
                            physics:
                                state.status == HomeStatus.fillProfileNeeded
                                    ? const NeverScrollableScrollPhysics()
                                    : const ScrollPhysics(),
                            children: [
                              state.status == HomeStatus.error
                                  ? const Icon(Icons.error_outline)
                                  : ChatsScreen(
                                      onChatTap: (_) {},
                                      conversations:
                                          state.currentUser?.conversations,
                                      onChatAdd: () {
                                        context.go('/FindUsersScreen');
                                      }),
                              const Icon(Icons.location_on),
                              UserInfoScreen(
                                  onPhotoAdd: () => context
                                      .read<HomeCubit>()
                                      .addPhoto(
                                          currentUID: state.currentUser!.uid),
                                  onFirstNameChanged: (value) => context
                                      .read<HomeCubit>()
                                      .firstNameChanged(value),
                                  onLastNameChanged: (value) => context
                                      .read<HomeCubit>()
                                      .lastNameChanged(value),
                                  onEmailChanged: (value) => context
                                      .read<HomeCubit>()
                                      .emailChanged(value),
                                  onPhoneChanged: (value) => context
                                      .read<HomeCubit>()
                                      .phoneChanged(value),
                                  firstNameController: firstNameController
                                    ..text = state.newFirstName ?? '',
                                  lastNameController: lastNameController
                                    ..text = state.newLastName ?? '',
                                  emailController: emailController
                                    ..text = state.newEmail ?? '',
                                  phoneController: phoneController
                                    ..text = state.newPhoneNumber ?? '',
                                  onSave: context.read<HomeCubit>().isProfileDataChanged &&
                                          context.read<HomeCubit>().isFormsValid
                                      ? () => context.read<HomeCubit>().updateUserInfo(currentUID: state.currentUser!.uid, newFirstName: firstNameController.text, newLastName: lastNameController.text, newEmail: emailController.text, newPhoneNumber: phoneController.text)
                                      : null,
                                  onSignOut: () {
                                    context.read<HomeCubit>().signOut();
                                    context.go('/EmailAuthScreen');
                                  },
                                  userInfo: state.currentUser?.userInfo,
                                  status: state.status),
                            ],
                          ),
                  );
                })),
          );
        },
      ),
    );
  }
}

class PersonalInfoTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String) onChanged;
  const PersonalInfoTextInput(
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
            prefixIcon: const Icon(Icons.person)),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
