import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/cubits/chats/chats_cubit.dart';
import 'package:chats/feature/home/cubits/user_info/user_info_cubit.dart';
import 'package:chats/feature/home/screens/chats_screen.dart';
import 'package:chats/feature/home/cubits/home/home_cubit.dart';
import 'package:chats/feature/home/screens/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chats/app_constants.dart' as constants;

class HomeScreen extends StatelessWidget {
  final TextEditingController messageInputController = TextEditingController();
  final TextEditingController searchUsersInputController =
      TextEditingController();
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: statusListener,
      builder: (context, state) {
        return MaterialApp(
          home: DefaultTabController(
              length: 3,
              child: Builder(builder: (context) {
                TabController tabController = DefaultTabController.of(context);
                if (state.status == HomeStatus.fillProfileNeeded) {
                  tabController.animateTo(2);
                }
                return Scaffold(
                  appBar: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                        systemNavigationBarColor:
                            constants.bottomNavigationBarColor),
                    backgroundColor: constants.appBarColor,
                    title: const SizedBox(
                      height: constants.mainLogoSmallSize,
                      child: MainLogo(),
                    ),
                  ),
                  bottomNavigationBar: Container(
                      color: constants.bottomNavigationBarColor,
                      child: SafeArea(
                          child: IgnorePointer(
                              ignoring:
                                  state.status == HomeStatus.fillProfileNeeded,
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
                                        icon:
                                            Icon(size: 35, Icons.location_on)),
                                    Tab(
                                        icon: Icon(
                                            size: 35,
                                            constants.defaultPersonIcon)),
                                  ])))),
                  body: state.status == HomeStatus.initial
                      ? const Center(child: CircularProgressIndicator())
                      : TabBarView(
                          physics: state.status == HomeStatus.fillProfileNeeded
                              ? const NeverScrollableScrollPhysics()
                              : const ScrollPhysics(),
                          children: [
                            state.status == HomeStatus.error
                                ? const Icon(Icons.error_outline)
                                : const ChatsScreen(),
                            const Icon(Icons.location_on),
                            UserInfoScreen(),
                          ],
                        ),
                );
              })),
        );
      },
    );
  }

  void statusListener(BuildContext context, HomeState state) {
    if (state.status == HomeStatus.fillProfileNeeded) {
      context.read<UserInfoCubit>().loadUser(state.currentUser!);
      context.read<ChatsCubit>().loadChats(state.currentUser!.conversations);
      Flushbar(
        message: constants.onFillUserInfo,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 4),
      ).show(context);
    } else if (state.status == HomeStatus.userLoaded) {
      context.read<UserInfoCubit>().loadUser(state.currentUser!);
      context.read<ChatsCubit>().loadChats(state.currentUser!.conversations);
    } else if (state.status == HomeStatus.error) {
      Flushbar(
              message: constants.homeScreenError,
              flushbarPosition: FlushbarPosition.TOP)
          .show(context);
    }
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
