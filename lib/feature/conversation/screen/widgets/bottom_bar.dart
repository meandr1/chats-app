import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/cubits/voice_recording_cubit/voice_recording_cubit.dart';
import 'package:chats/feature/conversation/screen/widgets/message_text_input.dart';
import 'package:chats/feature/conversation/screen/widgets/popup_menu_photo_button.dart';
import 'package:chats/feature/conversation/screen/widgets/recording_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBar extends StatelessWidget {
  final TextEditingController messageInputController;
  const BottomBar({super.key, required this.messageInputController});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceRecordingCubit, VoiceRecordingState>(
      listener: voiceRecordingStateListener,
      builder: (BuildContext context, VoiceRecordingState state) => Container(
        color: AppConstants.bottomNavigationBarColor,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: SafeArea(
          child: Row(children: [
            const Padding(
                padding: EdgeInsets.only(right: 10),
                child: PopupMenuPhotoButton()),
            MicButton(messageInputController: messageInputController),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MessageTextInput(controller: messageInputController),
                  if (context.read<VoiceRecordingCubit>().isRecording)
                    const Positioned.fill(
                      child: RecordingWidget(),
                    ),
                ],
              ),
            ),
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

  void voiceRecordingStateListener(
      BuildContext context, VoiceRecordingState state) {
    if (state.status == VoiceRecordingStatus.recordingSuccess) {
      context.read<ConversationCubit>().sendFileMessage(
          fileUrl: state.fileUrl!, type: AppConstants.voiceType);
      context.read<VoiceRecordingCubit>().clearState();
    }
  }
}
