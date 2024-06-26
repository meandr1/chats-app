import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chats/app_constants.dart';
import 'package:chats/models/message.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageBubble extends StatelessWidget {
  final Message message;
  final bool isMyMessage;

  const ImageBubble(
      {super.key, required this.message, required this.isMyMessage});

  @override
  Widget build(BuildContext context) {
    const double padding = 3;
    final maxWidth = MediaQuery.of(context).size.width * 
    AppConstants.chatBubbleWidthFactor - padding * 2;
    final maxHeight = MediaQuery.of(context).size.width *
            AppConstants.chatBubbleHeightFactor - padding * 2;
    final bubbleBorderRadius = BorderRadius.only(
        topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius),
        topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius),
        bottomRight: Radius.circular(isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius),
        bottomLeft: Radius.circular(isMyMessage ? AppConstants.chatBubbleBorderRadius : 0));
    final imageBorderRadius = BorderRadius.only(
        topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius - padding),
        topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius - padding),
        bottomRight: Radius.circular(isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius - padding),
        bottomLeft: Radius.circular(isMyMessage ? AppConstants.chatBubbleBorderRadius - padding : 0));

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      decoration: BoxDecoration(
          color: (isMyMessage
              ? AppConstants.chatBubbleSentColor
              : AppConstants.chatBubbleReceivedColor),
          borderRadius: bubbleBorderRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          CachedNetworkImage(
              imageUrl: message.text,
              imageBuilder: (context, imageProvider) {
                return FutureBuilder<Size>(
                    future: _getImageSize(imageProvider),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final size = snapshot.data!;
                        double width = size.width;
                        double height = size.height;
                        if (width > maxWidth) {
                          final ratio = width / maxWidth;
                          height = height / ratio;
                        }
                        return GestureDetector(
                          onTap: () => showImageViewer(context, imageProvider,
                              doubleTapZoomable: true, swipeDismissible: true),
                          child: Container(
                            height: height,
                            width: width,
                            constraints: BoxConstraints(
                              maxWidth: maxWidth,
                              maxHeight: maxHeight,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: imageBorderRadius,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    });
              }),
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

  Future<Size> _getImageSize(ImageProvider imageProvider) async {
    final Completer<Size> completer = Completer<Size>();
    final ImageStream imageStream = imageProvider.resolve(const ImageConfiguration());
    final ImageStreamListener listener = ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
    });
    imageStream.addListener(listener);
    return completer.future;
  }
}
