part of 'voice_recording_cubit.dart';

enum VoiceRecordingStatus { initial, inProgress, recordingSuccess, error }

class VoiceRecordingState extends Equatable {
  final VoiceRecordingStatus status;
  final String? fileUrl;

  const VoiceRecordingState({required this.status, this.fileUrl});

  @override
  List<Object?> get props => [status, fileUrl];

  factory VoiceRecordingState.initial() {
    return const VoiceRecordingState(status: VoiceRecordingStatus.initial);
  }

  VoiceRecordingState copyWith(
      {VoiceRecordingStatus? status, String? fileUrl}) {
    return VoiceRecordingState(
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
