import 'package:chats/feature/common_widgets/get_avatar_widget.dart';
import 'package:chats/feature/conversation/cubits/voice_recording_cubit/voice_recording_cubit.dart';
import 'package:chats/feature/conversation/screen/widgets/chat_bubble.dart';
import 'package:chats/feature/conversation/screen/widgets/image_bubble.dart';
import 'package:chats/feature/conversation/screen/widgets/video_bubble.dart';
import 'package:chats/feature/conversation/screen/widgets/wave_bubble.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/models/message.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessagesList extends StatelessWidget {
  final List<Message> messages;
  final String companionPhotoURL;
  final String? companionID;

  const MessagesList(
      {super.key,
      required this.messages,
      required this.companionPhotoURL,
      required this.companionID});

  @override
  Widget build(BuildContext context) {
    if (messages.isNotEmpty) {
      final reversed = messages.reversed.toList();
      return ListView.builder(
          cacheExtent: AppConstants.cacheExtent,
          reverse: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: reversed.length,
          itemBuilder: (BuildContext context, int index) {
            final key = ValueKey(reversed[index].text);
            final bool isMyMessage = companionID != reversed[index].sender;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                children: [
                  getDateWidget(reversed, index),
                  Row(
                    mainAxisAlignment: isMyMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMyMessage)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FutureBuilder(
                              future: context
                                  .read<HomeCubit>()
                                  .getFile(companionPhotoURL),
                              builder: (_, snapshot) => getAvatarWidget(
                                  noAvatarIcon: AppConstants.defaultPersonIcon,
                                  snapshot: snapshot,
                                  photoUrl: companionPhotoURL,
                                  diameter:
                                      AppConstants.conversationAvatarDia)),
                        ),
                      reversed[index].type == AppConstants.textType
                          ? ChatBubble(
                              key: key,
                              message: reversed[index],
                              isMyMessage: isMyMessage)
                          : reversed[index].type == AppConstants.voiceType
                              ? WaveBubble(
                                  key: key,
                                  recordingInProgress: context
                                      .read<VoiceRecordingCubit>()
                                      .isRecording,
                                  width: MediaQuery.of(context).size.width *
                                      AppConstants.waveBubbleWidthFactor,
                                  message: reversed[index],
                                  isMyMessage: isMyMessage)
                              : reversed[index].type == AppConstants.imageType
                                  ? ImageBubble(
                                      key: key,
                                      message: reversed[index],
                                      isMyMessage: isMyMessage)
                                  : VideoBubble(
                                      key: key,
                                      message: reversed[index],
                                      isMyMessage: isMyMessage)
                    ],
                  ),
                ],
              ),
            );
          });
    } else {
      return ListView();
    }
  }

  Widget getDateWidget(List<Message> messages, int index) {
    final currentTimestamp = messages[index].timestamp?.toDate();
    final isNotFirstMessage = index < messages.length - 1;
    final nextTimestamp =
        isNotFirstMessage ? messages[index + 1].timestamp?.toDate() : null;
    if (currentTimestamp == null ||
        (nextTimestamp == null && isNotFirstMessage) ||
        DateUtils.isSameDay(currentTimestamp, nextTimestamp)) {
      return const SizedBox.shrink();
    }
    return Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10)),
        child: currentTimestamp.isAfter(DateTime(DateTime.now().year))
            ? Text(DateFormat('dd MMM').format(currentTimestamp))
            : Text(DateFormat('dd MMM yy').format(currentTimestamp)));
  }
}
