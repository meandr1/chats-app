import 'dart:async';
import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/conversation_cubit/conversation_cubit.dart';
import 'package:chats/feature/conversation/voice_recording_cubit/voice_recording_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordingWidget extends StatefulWidget {
  const RecordingWidget({super.key});

  @override
  State<RecordingWidget> createState() => _RecordingWidgetState();
}

class _RecordingWidgetState extends State<RecordingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Stopwatch _stopwatch = Stopwatch();
  late Duration _elapsedTime;
  late String _elapsedTimeString;
  late Timer _timer;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.repeat(reverse: true);
    _elapsedTime = Duration.zero;
    _elapsedTimeString = _formatElapsedTime(_elapsedTime);
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      if (_stopwatch.isRunning) {
        _updateElapsedTime();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  String _formatElapsedTime(Duration time) {
    return '${time.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
        '${(time.inSeconds.remainder(60)).toString().padLeft(2, '0')}.'
        '${(time.inMilliseconds % 1000 ~/ 100).toString()}';
  }

  void _updateElapsedTime() {
    setState(() {
      _elapsedTime = _stopwatch.elapsed;
      _elapsedTimeString = _formatElapsedTime(_elapsedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          color: AppConstants.bottomNavigationBarColor,
          child: Row(children: [
                FadeTransition(
            opacity: _animationController,
            child: const Icon(Icons.circle, color: Colors.red, size: 15)),
                const SizedBox(width: 10),
                Text(_elapsedTimeString, style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 10),
                const Text('Swipe to cancel ->', style: TextStyle(color: Colors.white))
              ]),
        ));
  }
}

class MicButton extends StatelessWidget {
  const MicButton({
    super.key,
    required this.messageInputController,
  });

  final TextEditingController messageInputController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) {
        context.read<ConversationCubit>().setRecording(true);
        context.read<VoiceRecordingCubit>().startRecording();
        messageInputController.clear();
      },
      onLongPressEnd: (_) {
        context.read<ConversationCubit>().setRecording(false);
        context.read<VoiceRecordingCubit>().stopRecording();
      },
      onLongPressMoveUpdate: (movement) {
        if (movement.offsetFromOrigin.dx >
            AppConstants.recordingCancelSwipeDistance) {
          context.read<ConversationCubit>().setRecording(false);
          context.read<VoiceRecordingCubit>().recordingCanceled();
        }
      },
      child: Padding(
          padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
          child: context.read<ConversationCubit>().isRecording
              ? const Icon(Icons.mic_outlined, color: Colors.white)
              : const Icon(Icons.mic_none_outlined, color: Colors.white)),
    );
  }
}
