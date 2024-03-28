import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatsWidget extends StatelessWidget {
  final void Function() onPressed;
  const ChatsWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
        create: (context) => HomeCubit(HomeRepository()),
        child: Column(children: <Widget>[
          Expanded(
              child: ListView(children: [
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
          ])),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: constants.elevatedButtonColor,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10)),
                  onPressed: onPressed,
                  child: const Icon(size: 40, Icons.add),
                )),
          ),
        ]));
  }
}
