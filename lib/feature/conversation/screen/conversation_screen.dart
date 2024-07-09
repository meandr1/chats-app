import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/conversation/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/screen/messages_list.dart';
import 'package:chats/feature/conversation/screen/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ConversationScreen extends StatelessWidget {
  final TextEditingController messageInputController = TextEditingController();
  ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationCubit, ConversationState>(
        buildWhen: (previous, current) =>
            current.messagesList != previous.messagesList,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                  systemNavigationBarColor:
                      AppConstants.bottomNavigationBarColor),
              leading: BackButton(onPressed: (() {
                context.read<ConversationCubit>().cancelMessagesSubscription();
                context.go('/');
              })),
              backgroundColor: AppConstants.appBarColor,
              title: SizedBox(
                height: AppConstants.mainLogoSmallSize,
                child: MainLogo(text: state.companionName),
              ),
            ),
            body: Column(children: [
              Expanded(
                  child: state.status == ConversationStatus.initial
                      ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator())
                      : state.status == ConversationStatus.error
                          ? const Icon(Icons.error)
                          : GestureDetector(
                              onTap: () =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              child: MessagesList(
                                messages: state.messagesList,
                                companionID: state.companionID,
                                companionPhotoURL:
                                    state.companionPhotoURL ?? '',
                              ),
                            )),
              BottomBar(messageInputController: messageInputController),
            ]),
          );
        });
  }
}
