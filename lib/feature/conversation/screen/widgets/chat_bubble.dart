import 'package:any_link_preview/any_link_preview.dart';
import 'package:chats/app_constants.dart';
import 'package:chats/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMyMessage;

  const ChatBubble(
      {super.key, required this.message, required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    const double previewWidgetPadding = 5;
    final bool isUrlValid = AnyLinkPreview.isValidLink(message.text);
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width *
              AppConstants.chatBubbleWidthFactor),
      padding: EdgeInsets.symmetric(
          horizontal: isUrlValid ? previewWidgetPadding : 10,
          vertical: previewWidgetPadding),
      decoration: BoxDecoration(
        color: (isMyMessage
            ? AppConstants.chatBubbleSentColor
            : AppConstants.chatBubbleReceivedColor),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius),
          topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius),
          bottomRight: Radius.circular(isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius),
          bottomLeft: Radius.circular(isMyMessage ? AppConstants.chatBubbleBorderRadius : 0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          isUrlValid
              ? _previewWidget(context, previewWidgetPadding)
              : Text(message.text, style: AppConstants.chatBubbleTextStyle),
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

  Widget _previewWidget(BuildContext context, double previewWidgetPadding) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(
              AppConstants.chatBubbleBorderRadius - previewWidgetPadding))),
      child: AnyLinkPreview(
        onTap: () => launchUrl(Uri.parse(message.text)),
        link: message.text,
        displayDirection: UIDirection.uiDirectionHorizontal,
        showMultimedia: true,
        bodyMaxLines: 5,
        removeElevation: true,
        bodyTextOverflow: TextOverflow.ellipsis,
        titleStyle: AppConstants.chatBubbleTextStyle,
        cache: const Duration(days: 7),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bodyStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        errorTitle: 'Can\'t find title, or title is empty',
        errorBody: 'Can\'t find description, or description is empty',
        errorWidget: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(
                  AppConstants.chatBubbleBorderRadius - previewWidgetPadding))),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                    text: 'Oops! Seems to be an URL ',
                    style: TextStyle(color: Colors.black)),
                TextSpan(
                    style: const TextStyle(
                        color: AppConstants.textButtonColor,
                        decoration: TextDecoration.underline),
                    text: message.text),
                const TextSpan(
                    text: ' is broken', style: TextStyle(color: Colors.black))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
