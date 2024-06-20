import 'package:chats/app_constants.dart';
import 'package:chats/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMyMessage;

  const ChatBubble(
      {super.key, required this.message, required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              AppConstants.chatBubbleMaxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
