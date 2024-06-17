import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/models/message.dart';
import 'package:flutter/material.dart';
import 'package:chats/app_constants.dart';
import 'package:intl/intl.dart';

class MessagesList extends StatelessWidget {
  final List<Message?>? messages;
  final String companionPhotoURL;
  final String? companionID;

  const MessagesList(
      {super.key,
      required this.messages,
      required this.companionPhotoURL,
      required this.companionID});

  @override
  Widget build(BuildContext context) {
    if (messages != null && messages!.isNotEmpty) {
      final reversed = messages!.reversed.toList();
      return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.all(8.0),
          itemCount: messages!.length,
          itemBuilder: (BuildContext context, int index) {
            final bool isMyMessage = companionID != reversed[index]?.sender;
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
                      ChatBubble(
                          message: reversed[index]!,
                          companionPhotoURL: companionPhotoURL,
                          isMyMessage: isMyMessage),
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

  Widget getDateWidget(List<Message?> messages, int index) {
    final currentTimestamp = messages[index]?.timestamp?.toDate();
    final isNotFirstMessage = index < messages.length - 1;
    final nextTimestamp =
        isNotFirstMessage ? messages[index + 1]?.timestamp?.toDate() : null;
    if (currentTimestamp == null ||
        (nextTimestamp == null && isNotFirstMessage) ||
        DateUtils.isSameDay(currentTimestamp, nextTimestamp)) {
      return const SizedBox.shrink();
    }
    return Container(
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
        ? CachedNetworkImage(
            imageUrl: companionPhotoURL,
            imageBuilder: (context, imageProvider) => Container(
                width: AppConstants.conversationAvatarDia,
                height: AppConstants.conversationAvatarDia,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover))),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/broken_image.png'))
        : const Icon(
            size: AppConstants.imageDiameterSmall,
            AppConstants.defaultPersonIcon,
            color: AppConstants.iconsColor);
  }
}

class ChatBubble extends StatelessWidget {
  final Message message;
  final String companionPhotoURL;
  final bool isMyMessage;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.companionPhotoURL,
      required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: (isMyMessage
            ? AppConstants.chatBubbleSentColor
            : AppConstants.chatBubbleReceivedColor),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius),
          topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius),
          bottomRight: Radius.circular(
              isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius),
          bottomLeft: Radius.circular(
              isMyMessage ? AppConstants.chatBubbleBorderRadius : 0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(message.text, style: AppConstants.chatBubbleTextStyle),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                message.timestamp != null
                    ? DateFormat('MMM d – HH:mm')
                        .format(message.timestamp!.toDate())
                    : '',
                style: const TextStyle(
                    fontSize: AppConstants.chatBubbleMetaFontSize),
              ),
              const SizedBox(width: 5),
              if (isMyMessage)
                message.status == AppConstants.messageReadStatus
                    ? const Icon(Icons.done_all,
                        size: AppConstants.chatBubbleMetaFontSize)
                    : message.status == AppConstants.messageDeliveredStatus
                        ? const Icon(Icons.done,
                            size: AppConstants.chatBubbleMetaFontSize)
                        : const SizedBox.shrink()
            ],
          ),
        ],
      ),
    );
  }
}
