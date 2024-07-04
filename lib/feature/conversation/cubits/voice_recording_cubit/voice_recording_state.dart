part of 'voice_recording_cubit.dart';

enum VoiceRecordingStatus { initial, inProgress, recordingSuccess, error }

class VoiceRecordingState extends Equatable {
  final VoiceRecordingStatus status;
  final String? fileUrl;
  final bool recording;
  final bool voiceMessagePlaying;

  const VoiceRecordingState(
      {required this.recording,
      required this.voiceMessagePlaying,
      required this.status,
      this.fileUrl});

  @override
  List<Object?> get props => [status, fileUrl, recording, voiceMessagePlaying];

  factory VoiceRecordingState.initial() {
    return const VoiceRecordingState(
        status: VoiceRecordingStatus.initial,
        recording: false,
        voiceMessagePlaying: false);
  }

  VoiceRecordingState copyWith(
      {VoiceRecordingStatus? status,
      String? fileUrl,
      bool? recording,
      bool? voiceMessagePlaying}) {
    return VoiceRecordingState(
      recording: recording ?? this.recording,
      voiceMessagePlaying: voiceMessagePlaying ?? this.voiceMessagePlaying,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
