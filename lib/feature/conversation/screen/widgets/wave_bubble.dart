import 'dart:async';
import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/cubits/voice_recording_cubit/voice_recording_cubit.dart';
import 'package:chats/feature/home/cubit/home_cubit.dart';
import 'package:chats/models/message.dart';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WaveBubble extends StatefulWidget {
  final Message message;
  final bool isMyMessage;
  final bool recordingInProgress;
  final double width;

  const WaveBubble(
      {required super.key,
      required this.message,
      required this.isMyMessage,
      required this.recordingInProgress,
      required this.width});

  @override
  State<WaveBubble> createState() => _WaveBubbleState();
}

class _WaveBubbleState extends State<WaveBubble> {
  late PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubscription;
  final playerWaveStyle = const PlayerWaveStyle(
      fixedWaveColor: Colors.white54, liveWaveColor: Colors.white);

  @override
  void initState() {
    super.initState();
    playerController = PlayerController();
    _preparePlayer();
    playerStateSubscription =
        playerController.onPlayerStateChanged.listen((playerState) {
      context
          .read<VoiceRecordingCubit>()
          .voiceMessagePlaying(playerState == PlayerState.playing);
      setState(() {});
    });
  }

  Future<void> _preparePlayer() async {
    final file = await context.read<HomeCubit>().getFile(widget.message.text);
    if (file != null) {
      await playerController.preparePlayer(
          path: file.path,
          noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width));
    }
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    playerController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WaveBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.recordingInProgress) playerController.pausePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *
          AppConstants.chatBubbleWidthFactor,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
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
                        : !context
                                .read<VoiceRecordingCubit>()
                                .isVoiceMessagePlaying
                            ? await playerController.startPlayer(
                                finishMode: FinishMode.pause)
                            : null;
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
