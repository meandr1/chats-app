import 'dart:io' show File;
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chats/app_constants.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeState.initial());

  Future<void> getCurrentUserInfo() async {
    try {
      final currentUser = await _homeRepository.getCurrentUserInfo();
      if (currentUser != null) {
        emit(state.copyWith(
            status: isFillPersonalDataNeeded(currentUser)
                ? HomeStatus.fillProfileNeeded
                : HomeStatus.userLoaded,
            currentUser: currentUser));
      } else {
        emit(state.copyWith(
            status: HomeStatus.error, errorMessage: AppConstants.unknownError));
      }
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.message));
    }
  }

  bool isFillPersonalDataNeeded(FirebaseUser user) {
    final info = user.userInfo;
    return info.email == null ||
        info.email!.isEmpty ||
        info.firstName == null ||
        info.firstName!.isEmpty ||
        info.lastName == null ||
        info.lastName!.isEmpty ||
        info.phoneNumber == null ||
        info.phoneNumber!.isEmpty;
  }

  Future<void> addUserIfNotExists(
      {required String provider, required User user}) async {
    try {
      await _homeRepository.addUserIfNotExists(provider: provider, user: user);
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.message));
    }
  }

   Future<File?> getFile(String? fileUrl) async {
    if (fileUrl?.isNotEmpty ?? false) {
      return await _homeRepository.getFile(fileUrl!);
    }
    return null;
  }
}
