import 'dart:async';
import 'package:chats/app_constants.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/models/message.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ImageBubble extends StatefulWidget {
  final Message message;
  final bool isMyMessage;

  const ImageBubble(
      {super.key, required this.message, required this.isMyMessage});

  @override
  State<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  late Future<Size> imageSize;
  late ImageProvider<Object> imageProvider;

  @override
  void initState() {
    super.initState();
    imageSize = _prepareImageProvider();
  }

  Future<Size> _prepareImageProvider() {
    final file = context.read<HomeCubit>().getFile(widget.message.text);
    return file.then((value) {
      imageProvider = value != null
          ? FileImage(value)
          : const AssetImage(AppConstants.failedToLoadChatImageAsset)
              as ImageProvider;
      return _getImageSize(imageProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 3;
    final maxWidth =
        MediaQuery.of(context).size.width * AppConstants.chatBubbleWidthFactor -
            padding * 2;
    final maxHeight = MediaQuery.of(context).size.width *
            AppConstants.chatBubbleHeightFactor -
        padding * 2;
    final bubbleBorderRadius = BorderRadius.only(
        topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius),
        topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius),
        bottomRight: Radius.circular(
            widget.isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius),
        bottomLeft: Radius.circular(
            widget.isMyMessage ? AppConstants.chatBubbleBorderRadius : 0));
    final imageBorderRadius = BorderRadius.only(
        topLeft: const Radius.circular(
            AppConstants.chatBubbleBorderRadius - padding),
        topRight: const Radius.circular(
            AppConstants.chatBubbleBorderRadius - padding),
        bottomRight: Radius.circular(widget.isMyMessage
            ? 0
            : AppConstants.chatBubbleBorderRadius - padding),
        bottomLeft: Radius.circular(widget.isMyMessage
            ? AppConstants.chatBubbleBorderRadius - padding
            : 0));
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: padding, vertical: padding),
      decoration: BoxDecoration(
          color: (widget.isMyMessage
              ? AppConstants.chatBubbleSentColor
              : AppConstants.chatBubbleReceivedColor),
          borderRadius: bubbleBorderRadius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.isMyMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder<Size>(
              future: imageSize,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
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
              }),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.message.timestamp != null
                    ? DateFormat('MMM d – HH:mm')
                        .format(widget.message.timestamp!.toDate())
                    : '',
                style: const TextStyle(
                    fontSize: AppConstants.chatBubbleMetaFontSize),
              ),
              const SizedBox(width: 5),
              if (widget.isMyMessage)
                widget.message.status == AppConstants.messageReadStatus
                    ? const Icon(Icons.done_all,
                        size: AppConstants.chatBubbleMetaFontSize)
                    : widget.message.status ==
                            AppConstants.messageDeliveredStatus
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
    final ImageStream imageStream =
        imageProvider.resolve(const ImageConfiguration());
    void listener(ImageInfo info, bool _) {
      completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()));
      imageStream.removeListener(ImageStreamListener(listener));
    }

    imageStream.addListener(ImageStreamListener(listener));
    return completer.future;
  }
}
