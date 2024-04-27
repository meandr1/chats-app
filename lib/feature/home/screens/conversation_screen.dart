import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/cubits/conversation/conversation_cubit.dart';
import 'package:chats/feature/home/screens/widgets/get_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ConversationScreen extends StatelessWidget {
  final TextEditingController messageInputController = TextEditingController();

  final String? conversationID;
  final String companionID;
  final String companionName;
  final String companionPhotoURL;

  ConversationScreen({
    super.key,
    this.conversationID,
    required this.companionID,
    required this.companionName,
    required this.companionPhotoURL,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConversationCubit, ConversationState>(
        listener: stateListener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                  systemNavigationBarColor:
                      AppConstants.bottomNavigationBarColor),
              leading: BackButton(onPressed: (() => context.go('/'))),
              backgroundColor: AppConstants.appBarColor,
              title: SizedBox(
                height: AppConstants.mainLogoSmallSize,
                child: MainLogo(text: companionName),
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
                          : MessagesList(conversations: [])),
              TapRegion(
                onTapInside: (event) => FocusScope.of(context).requestFocus(),
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                child: Container(
                  color: AppConstants.bottomNavigationBarColor,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: SafeArea(
                    child: Row(children: [
                      const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.attach_file, color: Colors.white)),
                      MessageTextInput(
                        controller: messageInputController,
                        onChanged: (_) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: messageInputController.text.trim().isNotEmpty
                              ? () {
                                  context.read<ConversationCubit>().sendMessage(
                                      message: messageInputController.text,
                                      conversationID: conversationID);
                                  messageInputController.text = '';
                                }
                              : null,
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ]),
          );
        });
  }

  void stateListener(BuildContext context, ConversationState state) {}
}

class MessageTextInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onChanged;
  const MessageTextInput(
      {super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 100),
        child: TextFormField(
          onChanged: onChanged,
          maxLines: null,
          controller: controller,
          decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)),
              floatingLabelBehavior: FloatingLabelBehavior.always),
        ),
      ),
    );
  }
}
