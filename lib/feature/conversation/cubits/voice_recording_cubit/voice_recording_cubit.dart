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

  void startRecording() async {
    emit(state.copyWith(status: VoiceRecordingStatus.inProgress));
    await recorderController.record();
  }

  void stopRecording() async {
    if(state.status != VoiceRecordingStatus.inProgress) return;
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
  }

  void clearState() {
    emit(VoiceRecordingState.initial());
  }
}
