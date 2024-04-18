import 'package:chats/feature/home/cubits/chats/chats_cubit.dart';
import 'package:chats/feature/home/cubits/find_users/find_users_cubit.dart';
import 'package:chats/feature/home/screens/widgets/get_chats_list.dart';

import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart' as constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        return Column(children: <Widget>[
          Expanded(
              child: ChatsList(
                  onChatTap: (uid) {},
                  conversations: state.status == ChatsStatus.conversationsLoaded
                      ? state.conversations
                      : null)),
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
                  onPressed: () {
                    context.push('/FindUsersScreen', extra: {
                      'onUserTap': (
                          {required String companionUID,
                          required String companionName,
                          required String companionPhotoURL}) {
                        context
                            .read<FindUsersCubit>()
                            .addConversationIfNotExists(
                                companionUID: companionUID,
                                companionName: companionName,
                                companionPhotoURL: companionPhotoURL);
                        context.push('/ConversationScreen', extra: {
                          'companionUID': companionUID,
                          'companionName': companionName,
                          'onBackButtonPress': () => context.go('/'),
                        });
                      },
                      'onBackButtonPress': () => context.go('/'),
                    });
                  },
                  child:
                      const Icon(size: constants.defaultButtonHigh, Icons.add),
                )),
          ),
        ]);
      },
    );
  }
}
