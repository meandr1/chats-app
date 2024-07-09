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

  const VoiceRecordingState(
      {required this.voiceMessagePlaying,
      required this.status,
      required this.micPermission,
      this.fileUrl});

  @override
  List<Object?> get props =>
      [status, fileUrl, voiceMessagePlaying, micPermission];

  factory VoiceRecordingState.initial() {
    return const VoiceRecordingState(
        status: VoiceRecordingStatus.initial,
        micPermission: false,
        voiceMessagePlaying: false);
  }

  VoiceRecordingState copyWith(
      {VoiceRecordingStatus? status,
      String? fileUrl,
      bool? micPermission,
      bool? voiceMessagePlaying}) {
    return VoiceRecordingState(
      micPermission: micPermission ?? this.micPermission,
      voiceMessagePlaying: voiceMessagePlaying ?? this.voiceMessagePlaying,
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
