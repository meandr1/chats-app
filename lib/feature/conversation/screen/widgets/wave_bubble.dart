import 'dart:async';
import 'package:chats/app_constants.dart';
import 'package:chats/models/message.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';

class WaveBubble extends StatefulWidget {
  final Message message;
  final bool isMyMessage;
  final double width;

  const WaveBubble(
      {super.key,
      required this.message,
      required this.isMyMessage,
      required this.width});

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late final PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubscription;
  final playerWaveStyle = const PlayerWaveStyle(
      fixedWaveColor: Colors.white54, liveWaveColor: Colors.white);

  @override
  void initState() {
    super.initState();
    playerController = PlayerController();
    _preparePlayer();
    playerStateSubscription = playerController.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
  }

  void _preparePlayer() async {
    final file = await DefaultCacheManager().getSingleFile(widget.message.text);
    await playerController.preparePlayer(
        path: file.path,
        noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width));
    await DefaultCacheManager().emptyCache();
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          MediaQuery.of(context).size.width * AppConstants.chatBubbleMaxWidth,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: (widget.isMyMessage
            ? AppConstants.chatBubbleSentColor
            : AppConstants.chatBubbleReceivedColor),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(AppConstants.chatBubbleBorderRadius),
          topRight: const Radius.circular(AppConstants.chatBubbleBorderRadius),
          bottomRight: Radius.circular(
              widget.isMyMessage ? 0 : AppConstants.chatBubbleBorderRadius),
          bottomLeft: Radius.circular(
              widget.isMyMessage ? AppConstants.chatBubbleBorderRadius : 0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.isMyMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  iconSize: 20,
                  onPressed: () async {
                    playerController.playerState.isPlaying
                        ? await playerController.pausePlayer()
                        : await playerController.startPlayer(
                            finishMode: FinishMode.pause);
                  },
                  icon: Icon(
                    playerController.playerState.isPlaying
                        ? Icons.stop
                        : Icons.play_arrow,
                  ),
                  color: Colors.white),
              AudioFileWaveforms(
                enableSeekGesture: true,
                size: Size(widget.width, 30),
                playerController: playerController,
                waveformType: WaveformType.fitWidth,
                playerWaveStyle: playerWaveStyle,
              ),
            ],
          ),
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
}
