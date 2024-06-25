import 'dart:async';
import 'package:chats/feature/auth/screens/widgets/main_logo.dart';
import 'package:chats/feature/conversation/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/screen/messages_list.dart';
import 'package:chats/feature/conversation/screen/widgets/message_text_input.dart';
import 'package:chats/feature/conversation/screen/widgets/popup_menu_photo_button.dart';
import 'package:chats/feature/conversation/screen/widgets/recording_widget.dart';
import 'package:chats/feature/conversation/voice_recording_cubit/voice_recording_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ConversationScreen extends StatelessWidget {
  final TextEditingController messageInputController = TextEditingController();
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      messagesSubscription;
  ConversationScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationCubit, ConversationState>(
        builder: (context, state) {
      conversationStateListener(context, state);
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: AppConstants.bottomNavigationBarColor),
          leading: BackButton(onPressed: (() {
            context.read<ConversationCubit>().clearState();
            messagesSubscription.cancel();
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
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: MessagesList(
                            messages: state.messagesList,
                            companionID: state.companionID,
                            companionPhotoURL: state.companionPhotoURL ?? '',
                          ),
                        )),
          bottomBar(context, state),
        ]),
      );
    });
  }

  Widget bottomBar(BuildContext context, ConversationState conversationState) {
    return BlocListener<VoiceRecordingCubit, VoiceRecordingState>(
      listener: voiceRecordingStateListener,
      child: Container(
        color: AppConstants.bottomNavigationBarColor,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: SafeArea(
          child: Row(children: [
            const Padding(
                padding: EdgeInsets.only(right: 10),
                child: PopupMenuPhotoButton()),
            MicButton(messageInputController: messageInputController),
            // TODO при открытой клавиатуре если начать запись, клавиатура прячется
            Visibility(
                visible: context.read<ConversationCubit>().isRecording,
                replacement:
                    MessageTextInput(controller: messageInputController),
                child: const RecordingWidget()),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  context.read<ConversationCubit>().sendMessage();
                  messageInputController.clear();
                },
                child: const Icon(Icons.send, color: Colors.white),
              ),
            )
          ]),
        ),
      ),
    );
  }

  void voiceRecordingStateListener(context, state) {
    if (state.status == VoiceRecordingStatus.recordingSuccess) {
      context.read<ConversationCubit>().sendVoiceMessage(state.fileUrl!);
      context.read<VoiceRecordingCubit>().clearState();
    }
  }

  void conversationStateListener(
      BuildContext context, ConversationState state) {
    if (state.status == ConversationStatus.initial) {
      if (state.conversationID == null) {
        context
            .read<ConversationCubit>()
            .addConversation(companionID: state.companionID);
      } else {
        messagesSubscription =
            context.read<ConversationCubit>().getConversationMessages();
      }
    }
  }
}
