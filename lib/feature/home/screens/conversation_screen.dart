import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/home/cubits/conversation/conversation_cubit.dart';
import 'package:chats/feature/home/screens/widgets/get_messages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chats/app_constants.dart' as constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ConversationScreen extends StatelessWidget {
  final TextEditingController messageInputController = TextEditingController();
  final String companionUID;
  final String companionName;
  final String companionPhotoURL;

  ConversationScreen(
      {super.key,
      required this.companionUID,
      required this.companionName,
      required this.companionPhotoURL});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationCubit, ConversationState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: constants.bottomNavigationBarColor),
            leading: BackButton(onPressed: (() => context.go('/'))),
            backgroundColor: constants.appBarColor,
            title: SizedBox(
              height: constants.mainLogoSmallSize,
              child: MainLogo(text: companionName),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                  child: state.status == ConversationStatus.initial
                      ? const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator())
                      : state.status == ConversationStatus.conversationLoaded
                          ? MessagesList(conversations: [])
                          : const Icon(Icons.error)),
              Container(
                  color: constants.bottomNavigationBarColor,
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  child: SafeArea(
                    child: Row(
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child:
                                Icon(Icons.attach_file, color: Colors.white)),
                        MessageTextInput(controller: messageInputController),
                        const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.send, color: Colors.white))
                      ],
                    ),
                  )),
            ],
          ));
    });
  }
}

class MessageTextInput extends StatelessWidget {
  final TextEditingController controller;
  const MessageTextInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 100),
        child: TextFormField(
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
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
        ),
      ),
    );
  }
}
