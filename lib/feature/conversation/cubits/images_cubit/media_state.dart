part of 'media_cubit.dart';

enum MediaStatus { initial, loadingSuccess, error, permissionNotGranted }

class MediaState extends Equatable {
  final MediaStatus status;
  final String? fileUrl;
  final String? type;

  const MediaState({required this.status, this.fileUrl, this.type});

  @override
  List<Object?> get props => [status, fileUrl, type];

  factory MediaState.initial() {
    return const MediaState(status: MediaStatus.initial);
  }

  MediaState copyWith({MediaStatus? status, String? fileUrl, String? type}) {
    return MediaState(
      status: status ?? this.status,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
