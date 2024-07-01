import 'package:chats/app_constants.dart';
import 'package:chats/models/message.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class VideoBubble extends StatefulWidget {
  final Message message;
  final bool isMyMessage;

  const VideoBubble(
      {required super.key, required this.message, required this.isMyMessage});

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  static const double padding = 3;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.message.text))
          ..initialize().then((value) => setState(() {}));
    _chewieController =
        ChewieController(videoPlayerController: _videoPlayerController);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final bubbleBorderRadius = BorderRadius.only(
        topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius),
        topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius),
        bottomRight: Radius.circular(widget.isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius),
        bottomLeft: Radius.circular(widget.isMyMessage ? AppConstants.chatBubbleBorderRadius : 0));
    final videoBorderRadius = BorderRadius.only(
        topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius - padding),
        topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius - padding),
        bottomRight: Radius.circular(widget.isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius - padding),
        bottomLeft: Radius.circular(widget.isMyMessage ? AppConstants.chatBubbleBorderRadius - padding : 0));

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
          _videoPlayerController.value.isInitialized
              ? Builder(builder: (context) {
                  final Size bubbleVideoSize = _getVideoBubbleSize(_videoPlayerController);
                  return GestureDetector(
                    onTap: () => _showFullScreenPlayer(context),
                    child: ClipRRect(
                        borderRadius: videoBorderRadius,
                        child: SizedBox(
                            width: bubbleVideoSize.width,
                            height: bubbleVideoSize.height,
                            child: Stack(
                              children: [
                                VideoPlayer(_videoPlayerController),
                                const Center(
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.white60,
                                    child: Icon(Icons.play_arrow,
                                        size: 40, color: Colors.white),
                                  ),
                                ),
                              ],
                            ))),
                  );
                })
              : const CircularProgressIndicator(),
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

  _showFullScreenPlayer(BuildContext context) {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
        builder: (context) {
          _chewieController.play();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
          return Dismissible(
            key: const Key('Full_screen_video_dismissible_dialog'),
            direction: DismissDirection.down,
            onDismissed: (_) {
              _chewieController.isPlaying ? _chewieController.pause() : null;
              Navigator.of(context).pop();
            },
            child: Dialog(
              backgroundColor: Colors.black,
              insetPadding: const EdgeInsets.all(0),
              shape:
                  const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              child: 
                Chewie(controller: _chewieController),
            ),
          );
        });
  }

  Size _getVideoBubbleSize(VideoPlayerController videoPlayerController) {
    final maxWidth = MediaQuery.of(context).size.width * 
            AppConstants.chatBubbleWidthFactor - padding * 2;
    final maxHeight = MediaQuery.of(context).size.width *
            AppConstants.chatBubbleHeightFactor - padding * 2;
    final ratio = _videoPlayerController.value.aspectRatio;
    final double width, height;
    if (ratio >= 1) {
      width = _videoPlayerController.value.size.width > maxWidth
          ? maxWidth
          : _videoPlayerController.value.size.width;
      height = width / ratio;
    } else {
      height = _videoPlayerController.value.size.height > maxHeight
          ? maxHeight
          : _videoPlayerController.value.size.height;
      width = height * ratio;
    }
    return Size(width, height);
  }
}
