import 'package:chats/feature/conversation/repository/images_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImagesRepository _imagesRepository;

  ImagesCubit(this._imagesRepository) : super(ImagesState.initial());

  void pickFile() async {
    final permission = await _imagesRepository.getPermission();
    if (permission) {
      final path = await _imagesRepository.pickFile();
      final fileUrl = await _imagesRepository.uploadImage(path);
      emit(state.copyWith(
          fileUrl: fileUrl, status: ImagesStatus.loadingSuccess));
    } else {
      emit(state.copyWith(status: ImagesStatus.permissionNotGranted));
    }
  }

  void clearState() {
    emit(ImagesState.initial());
  }
}
