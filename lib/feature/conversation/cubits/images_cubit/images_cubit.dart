import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/repository/images_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImagesRepository _imagesRepository;

  ImagesCubit(this._imagesRepository) : super(ImagesState.initial());

  void pickFile({required PopupMenuPhotoButtonItems item, BuildContext? context}) async {
    final permission = await _imagesRepository.getPermission();
    if (permission) {
      final String? path;
      switch (item) {
        case PopupMenuPhotoButtonItems.gallery:
          path = await _imagesRepository.pickFileFromGallery(context!);
          break;
        case PopupMenuPhotoButtonItems.photo:
          path = await _imagesRepository.takeAPhoto();
          break;
        case PopupMenuPhotoButtonItems.video:
          path = await _imagesRepository.recordAVideo();
          break;
      }
      if (path != null) {
        final fileUrl = await _imagesRepository.uploadImage(path);
        emit(state.copyWith(
            fileUrl: fileUrl, status: ImagesStatus.loadingSuccess));
      }
    } else {
      emit(state.copyWith(status: ImagesStatus.permissionNotGranted));
    }
  }

  void clearState() {
    emit(ImagesState.initial());
  }
}
