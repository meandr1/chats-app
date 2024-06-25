part of 'images_cubit.dart';

enum ImagesStatus { initial, loading, loadingSuccess, error }

class ImagesState extends Equatable {
  final ImagesStatus status;
  final String? fileUrl;

  const ImagesState({required this.status, this.fileUrl});

  @override
  List<Object?> get props => [status, fileUrl];

  factory ImagesState.initial() {
    return const ImagesState(status: ImagesStatus.initial);
  }

  ImagesState copyWith(
      {ImagesStatus? status, String? fileUrl}) {
    return ImagesState(
      status: status ?? this.status,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }
}
