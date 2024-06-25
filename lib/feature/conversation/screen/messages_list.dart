import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/feature/conversation/cubits/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/screen/widgets/chat_bubble.dart';
import 'package:chats/feature/conversation/screen/widgets/wave_bubble.dart';
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
          reverse: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: reversed.length,
          itemBuilder: (BuildContext context, int index) {
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
                          child: getAvatarImage(companionPhotoURL),
                        ),
                      reversed[index].type == AppConstants.textType
                          ? ChatBubble(
                              message: reversed[index],
                              isMyMessage: isMyMessage)
                          : reversed[index].type == AppConstants.voiceType
                              ? WaveBubble(
                                  recordingInProgress: context
                                      .read<ConversationCubit>()
                                      .isRecording,
                                  key: ValueKey(reversed[index].text),
                                  width: MediaQuery.of(context).size.width *
                                      AppConstants.chatBubbleMaxWidth *
                                      0.7,
                                  message: reversed[index],
                                  isMyMessage: isMyMessage)
                              : SizedBox.shrink()
                    ],
                  ),
                ],
              ),
            );
          });
    } else {
      return Container();
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

  Widget getAvatarImage(String photoURL) {
    return photoURL.isNotEmpty
        ? SizedBox(
            height: AppConstants.conversationAvatarDia,
            width: AppConstants.conversationAvatarDia,
            child: CachedNetworkImage(
                imageUrl: companionPhotoURL,
                imageBuilder: (context, imageProvider) => Container(
                    width: AppConstants.conversationAvatarDia,
                    height: AppConstants.conversationAvatarDia,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover))),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/broken_image.png')),
          )
        : const Icon(
            size: AppConstants.imageDiameterSmall,
            AppConstants.defaultPersonIcon,
            color: AppConstants.iconsColor);
  }
}
