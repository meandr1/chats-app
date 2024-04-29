import 'package:chats/feature/chats/cubit/chats_cubit.dart';
import 'package:chats/feature/chats/screen/widgets/get_chats_list.dart';
import 'package:chats/models/screens_args_transfer_objects.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';
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
                  onChatDelete: ({required companionID}) => context
                      .read<ChatsCubit>()
                      .deleteChat(companionID: companionID),
                  onChatTap: (
                      {required String companionID,
                      required String conversationID,
                      required String companionName,
                      required String companionPhotoURL}) {
                    context.push('/ConversationScreen',
                        extra: ChatsScreenArgsTransferObject(
                            conversationID: conversationID,
                            companionID: companionID,
                            companionName: companionName,
                            companionPhotoURL: companionPhotoURL));
                  },
                  conversations: state.conversations)),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 15, right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.elevatedButtonColor,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10)),
                  onPressed: () => context.go('/FindUsersScreen'),
                  child: const Icon(
                      size: AppConstants.defaultButtonHigh, Icons.add),
                )),
          ),
        ]);
      },
    );
  }
}
