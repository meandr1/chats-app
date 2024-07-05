part of 'voice_recording_cubit.dart';

enum VoiceRecordingStatus {
  initial,
  inProgress,
  recordingSuccess,
  error,
  micPermissionNotGranted
}

class VoiceRecordingState extends Equatable {
  final VoiceRecordingStatus status;
  final String? fileUrl;
  final bool voiceMessagePlaying;
  final bool micPermission;
  final bool recording;

  const VoiceRecordingState(
      {required this.voiceMessagePlaying,
      required this.status,
      required this.micPermission,
      required this.recording,
      this.fileUrl});

  @override
  List<Object?> get props =>
      [status, fileUrl, voiceMessagePlaying, micPermission, recording];

  factory VoiceRecordingState.initial() {
    return const VoiceRecordingState(
        status: VoiceRecordingStatus.initial,
        micPermission: false,
        recording: false,
        voiceMessagePlaying: false);
  }

  VoiceRecordingState copyWith(
      {VoiceRecordingStatus? status,
      String? fileUrl,
      bool? micPermission,
      bool? recording,
      bool? voiceMessagePlaying}) {
    return VoiceRecordingState(
      micPermission: micPermission ?? this.micPermission,
      recording: recording ?? this.recording,
      voiceMessagePlaying: voiceMessagePlaying ?? this.voiceMessagePlaying,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
