import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/repository/media_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  final MediaRepository _imagesRepository;

  MediaCubit(this._imagesRepository) : super(MediaState.initial());

  void pickFile(
      {required PopupMenuPhotoButtonItems item, BuildContext? context}) async {
    final permission = await _imagesRepository.getPermission();
    if (permission) {
      final String? path;
      final String? type;
      final bool? isImage;
      switch (item) {
        case PopupMenuPhotoButtonItems.gallery:
          path = await _imagesRepository.pickFileFromGallery(context!);
          isImage = _imagesRepository.isImage(path);
          type = isImage == null
              ? null
              : isImage
                  ? AppConstants.imageType
                  : AppConstants.videoType;
          break;
        case PopupMenuPhotoButtonItems.photo:
          path = await _imagesRepository.takeAPhoto();
          type = AppConstants.imageType;
          break;
        case PopupMenuPhotoButtonItems.video:
          path = await _imagesRepository.recordAVideo();
          type = AppConstants.videoType;
          break;
      }
      if (path != null) {
        if (type == null) {
          emit(state.copyWith(status: MediaStatus.error));
          return;
        }
        final fileUrl =
            await _imagesRepository.uploadImage(path: path, type: type);
        emit(state.copyWith(
            fileUrl: fileUrl, type: type, status: MediaStatus.loadingSuccess));
      }
    } else {
      emit(state.copyWith(status: MediaStatus.permissionNotGranted));
    }
  }

  void clearState() {
    emit(MediaState.initial());
  }
}
