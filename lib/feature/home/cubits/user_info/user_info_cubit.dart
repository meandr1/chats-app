import 'package:chats/feature/home/repository/user_info_repository.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  final UserInfoRepository _userInfoRepository;

  UserInfoCubit(this._userInfoRepository) : super(UserInfoState.initial());

  bool get isFormsValid {
    return Validator.emailValidator(state.email) == null &&
        Validator.phoneValidator(state.phoneNumber) == null &&
        state.firstName != '' &&
        state.lastName != '';
  }

  bool get isProfileDataChanged {
    final userInfo = state.currentUser?.userInfo;
    final phoneNumber = (userInfo?.phoneNumber ?? '').startsWith('+380')
        ? userInfo!.phoneNumber!.substring('+380'.length)
        : '';
    return userInfo?.firstName != state.firstName ||
        userInfo?.lastName != state.lastName ||
        userInfo?.email != state.email ||
        phoneNumber != state.phoneNumber;
  }

  void firstNameChanged(String? value) {
    emit(state.copyWith(firstName: value));
  }

  void lastNameChanged(String? value) {
    emit(state.copyWith(lastName: value));
  }

  void emailChanged(String? value) {
    emit(state.copyWith(email: value));
  }

  void phoneChanged(String? value) {
    emit(state.copyWith(phoneNumber: value));
  }

  void loadUser({required FirebaseUser user}) {
    String? phoneNumber = user.userInfo.phoneNumber;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      phoneNumber = phoneNumber.substring('+380'.length);
    }
    emit(state.copyWith(
        currentUser: user,
        firstName: user.userInfo.firstName,
        lastName: user.userInfo.lastName,
        email: user.userInfo.email,
        phoneNumber: phoneNumber,
        status: UserInfoStatus.userLoaded));
  }

  Future<void> updateUserInfo(
      {required String currentUID,
      String? newFirstName,
      String? newLastName,
      String? newEmail,
      String? provider,
      String? photoURL,
      String? newPhoneNumber}) async {
    emit(state.copyWith(status: UserInfoStatus.submitting));
    try {
      await _userInfoRepository.updateUserInfo(
          currentUID: currentUID,
          newEmail: newEmail,
          provider: provider,
          newPhotoURL: photoURL,
          newFirstName: newFirstName,
          newLastName: newLastName,
          newPhoneNumber: newPhoneNumber);
      emit(state.copyWith(status: UserInfoStatus.updated));
    } catch (e) {
      emit(state.copyWith(status: UserInfoStatus.error));
    }
  }

  Future<void> addPhoto({required String currentUID}) async {
    final permission = await _userInfoRepository.getPermission();
    final currentPhotoURL = state.currentUser?.userInfo.photoURL;
    if (permission) {
      try {
        final photoURL = await _userInfoRepository.uploadImage();
        if (photoURL != null) {
          await _userInfoRepository.updateUserInfo(
              currentUID: currentUID, newPhotoURL: photoURL);
          if (currentPhotoURL != null &&
              currentPhotoURL.startsWith('https://firebasestorage.googleapis.com')) {
            _userInfoRepository.deleteOldImage(currentPhotoURL);
          }
          emit(state.copyWith(status: UserInfoStatus.updated));
        } else {
          return;
        }
      } catch (e) {
        emit(state.copyWith(status: UserInfoStatus.error));
      }
    } else {
      emit(state.copyWith(status: UserInfoStatus.permissionNotGranted));
    }
  }

  Future<void> signOut() async {
    await _userInfoRepository.signOut();
  }
}
