import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chats/feature/conversation/repository/voice_recording_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'voice_recording_state.dart';

class VoiceRecordingCubit extends Cubit<VoiceRecordingState> {
  final VoiceRecordingRepository _voiceRecordingRepository;
  RecorderController recorderController = RecorderController()
    ..androidEncoder = AndroidEncoder.aac
    ..androidOutputFormat = AndroidOutputFormat.mpeg4
    ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
    ..sampleRate = 44100;

  VoiceRecordingCubit(this._voiceRecordingRepository)
      : super(VoiceRecordingState.initial());

  bool get isRecording {
    return state.status == VoiceRecordingStatus.inProgress;
  }

  bool get isMicPermissionGranted {
    return state.micPermission;
  }

  Future<void> checkMicPermission() async {
    final permission =
        await _voiceRecordingRepository.checkMicPermissionStatus();
    if (permission) {
      emit(state.copyWith(micPermission: permission));
    }
  }

  Future<void> getMicPermission() async {
    final permission = await _voiceRecordingRepository.getMicPermission();
    emit(state.copyWith(
        micPermission: permission,
        status: permission
            ? state.status
            : VoiceRecordingStatus.micPermissionNotGranted));
  }

  bool get isVoiceMessagePlaying {
    return state.voiceMessagePlaying;
  }

  void voiceMessagePlaying(bool isPlaying) {
    emit(state.copyWith(voiceMessagePlaying: isPlaying));
  }

  void startRecording() async {
    emit(state.copyWith(status: VoiceRecordingStatus.inProgress));
    await recorderController.record();
  }

  void stopRecording() async {
    if (state.status != VoiceRecordingStatus.inProgress) return;
    emit(state.copyWith(status: VoiceRecordingStatus.initial));
    recorderController.reset();
    final path = await recorderController.stop(false);
    final fileUrl = await _voiceRecordingRepository.uploadVoiceMessage(path);
    if (fileUrl != null) {
      emit(state.copyWith(
          status: VoiceRecordingStatus.recordingSuccess, fileUrl: fileUrl));
    } else {
      emit(state.copyWith(status: VoiceRecordingStatus.error));
    }
  }

  void recordingCanceled() async {
    if (recorderController.recorderState != RecorderState.stopped ||
        state.status == VoiceRecordingStatus.inProgress) {
      recorderController.reset();
      await recorderController.stop(false);
      emit(state.copyWith(status: VoiceRecordingStatus.initial));
    }
    emit(state.copyWith(status: VoiceRecordingStatus.initial));
  }

  void clearState() {
    emit(state.copyWith(status: VoiceRecordingStatus.initial));
  }
}
