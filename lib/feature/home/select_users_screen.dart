import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:chats/app_constants.dart' as constants;

class SelectUsersScreen extends StatelessWidget {
  final _searchUsersInputController = TextEditingController();

  SelectUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(HomeRepository()),
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                leading: BackButton(onPressed: () => context.go('/')),
                backgroundColor: constants.appBarColor,
                title: const SizedBox(
                  height: 80,
                  child: MainLogo(),
                ),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SearchUsersTextInput(
                        controller: _searchUsersInputController,
                        labelText: 'Search users:',
                        onChanged: (_) {}),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        child: const Text('add user'),
                        onPressed: () {
                          context.read<HomeCubit>().addUser();
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        child: const Text('add conversations'),
                        onPressed: () {
                          context.read<HomeCubit>().addConversations();
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        child: const Text('check User Provider'),
                        onPressed: () {
                          context.read<HomeCubit>().checkUserProvider(
                              uid: FirebaseAuth.instance.currentUser!.uid);
                        },
                      )),
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        child: const Text('sing out'),
                        onPressed: () {
                          context.read<HomeCubit>().signOut();
                          context.go('/EmailAuthScreen');
                        },
                      )),
                ],
              ));
        },
      ),
    );
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
            suffixIcon: const Icon(Icons.person)),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
