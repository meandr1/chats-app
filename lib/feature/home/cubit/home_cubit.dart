import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/helpers/validator.dart';
import 'package:chats/model/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeState.initial());

  bool get isFormsValid {
    return Validator.emailValidator(state.newEmail) == null &&
        Validator.phoneValidator(state.newPhoneNumber) == null &&
        state.newFirstName != '' &&
        state.newLastName != '';
  }

  bool get isProfileDataChanged {
    final userInfo = state.currentUser?.userInfo;
    return userInfo?.firstName != state.newFirstName ||
        userInfo?.lastName != state.newLastName ||
        userInfo?.email != state.newEmail ||
        userInfo?.phoneNumber != state.newPhoneNumber;
  }

  void firstNameChanged(String? value) {
    emit(state.copyWith(newFirstName: value));
  }

  void lastNameChanged(String? value) {
    emit(state.copyWith(newLastName: value));
  }

  void emailChanged(String? value) {
    emit(state.copyWith(newEmail: value));
  }

  void phoneChanged(String? value) {
    emit(state.copyWith(newPhoneNumber: value));
  }

  Future<void> addUser() async {
    await _homeRepository.addUser();
  }

  Future<void> getUsersList() async {
    final users = await _homeRepository.getUsersList();
    if (users != null) {
      emit(state.copyWith(
          status: HomeStatus.success, users: users, filteredUsers: users));
    } else {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  Future<void> getCurrentUserInfo() async {
    final currentUser = await _homeRepository.getCurrentUserInfo();
    if (currentUser != null) {
      emit(state.copyWith(
          newEmail: currentUser.userInfo.email,
          newFirstName: currentUser.userInfo.firstName,
          newLastName: currentUser.userInfo.lastName,
          newPhoneNumber: currentUser.userInfo.phoneNumber,
          status: isFillPersonalDataNeeded(currentUser)
              ? HomeStatus.fillProfileNeeded
              : HomeStatus.success,
          currentUser: currentUser));
    } else {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }

  Future<void> updateUserInfo(
      {String? newFirstName,
      String? newLastName,
      String? newEmail,
      String? newPhoneNumber}) async {
    emit(state.copyWith(status: HomeStatus.success));
  }

  Future<void> addConversations() async {
    await _homeRepository.addConversation();
  }

  void filterUsers(String pattern) {
    emit(state.copyWith(
        status: HomeStatus.success,
        filteredUsers: _homeRepository.filterUsers(state.users, pattern)));
  }

  Future<String?> checkUserProvider({required String uid}) async {
    return await _homeRepository.checkUserProvider(uid: uid);
  }

  Future<void> signOut() async {
    await _homeRepository.signOut();
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
}
