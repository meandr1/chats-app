import 'package:chats/feature/conversation/repository/images_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  final ImagesRepository _imagesRepository;

  ImagesCubit(this._imagesRepository)
      : super(ImagesState.initial());







}
