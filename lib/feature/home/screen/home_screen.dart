import 'package:another_flushbar/flushbar.dart';
import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/chats/cubit/chats_cubit.dart';
import 'package:chats/feature/map/cubit/map_cubit.dart';
import 'package:chats/feature/map/screen/map_screen.dart';
import 'package:chats/feature/user_info/cubit/user_info_cubit.dart';
import 'package:chats/feature/chats/screen/chats_screen.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/user_info/screen/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chats/app_constants.dart';

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
            child: Builder(
              builder: (context) {
                TabController tabController = DefaultTabController.of(context);
                if (state.status == HomeStatus.fillProfileNeeded) {
                  tabController.animateTo(2);
                }
                return Scaffold(
                  appBar: AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                        systemNavigationBarColor:
                            AppConstants.bottomNavigationBarColor),
                    backgroundColor: AppConstants.appBarColor,
                    title: const SizedBox(
                      height: AppConstants.mainLogoSmallSize,
                      child: MainLogo(),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    color: AppConstants.bottomNavigationBarColor,
                    child: SafeArea(
                      child: IgnorePointer(
                        ignoring: state.status == HomeStatus.fillProfileNeeded,
                        child: TabBar(
                          onTap: (index) {
                            if (index == 1) {
                              context.read<MapCubit>().updateMyPosition();
                            }
                          },
                          dividerHeight: 0,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white54,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: const EdgeInsets.all(5.0),
                          indicatorColor: Colors.white,
                          tabs: const [
                            Tab(icon: Icon(size: 35, Icons.messenger_outlined)),
                            Tab(icon: Icon(size: 35, Icons.location_on)),
                            Tab(
                                icon: Icon(
                                    size: 35, AppConstants.defaultPersonIcon)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: state.status == HomeStatus.initial
                      ? const Center(child: CircularProgressIndicator())
                      : TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            state.status == HomeStatus.error
                                ? const Icon(Icons.error_outline)
                                : const ChatsScreen(),
                            const MapScreen(),
                            UserInfoScreen(),
                          ],
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void statusListener(BuildContext context, HomeState state) {
    if (state.status == HomeStatus.fillProfileNeeded) {
      Flushbar(
        message: AppConstants.onFillUserInfo,
        flushbarPosition: FlushbarPosition.TOP,
        duration: const Duration(seconds: 4),
      ).show(context);
    } else if (state.status == HomeStatus.error) {
      Flushbar(
              message: state.errorMessage,
              flushbarPosition: FlushbarPosition.TOP)
          .show(context);
      return;
    }
    context.read<UserInfoCubit>().addUserToState(user: state.currentUser!);
    context.read<ChatsCubit>().loadChats(state.currentUser!.conversations);
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
    return TextFormField(
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
    );
  }
}
