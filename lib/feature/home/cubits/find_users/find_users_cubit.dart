
import 'package:chats/feature/home/repository/find_users_repository.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'find_users_state.dart';

class FindUsersCubit extends Cubit<FindUsersState> {
  final FindUsersRepository _findUsersRepository;

  FindUsersCubit(this._findUsersRepository) : super(FindUsersState.initial());

  Future<void> getUsersList() async {
    final users = await _findUsersRepository.getUsersList();
    if (users != null) {
      emit(state.copyWith(
          status: FindUsersStatus.success, users: users, filteredUsers: users));
    } else {
      emit(state.copyWith(status: FindUsersStatus.error));
    }
  }

  void filterUsers(String pattern) {
    emit(state.copyWith(
        status: FindUsersStatus.success,
        filteredUsers: _findUsersRepository.filterUsers(state.users, pattern)));
  }

  Future<void> addConversationIfNotExists(
      {required String companionUID,
      required String companionName,
      required String companionPhotoURL}) async {
    final res = await _findUsersRepository.addConversationIfNotExists(
        companionUID: companionUID,
        companionName: companionName,
        companionPhotoURL: companionPhotoURL);
    if (res == null) {
      emit(state.copyWith(status: FindUsersStatus.error));
    } else {
      emit(state.copyWith(status: FindUsersStatus.success));
    }
  }
}
