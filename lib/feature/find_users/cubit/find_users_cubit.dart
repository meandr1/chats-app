import 'package:chats/feature/find_users/repository/find_users_repository.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'find_users_state.dart';

class FindUsersCubit extends Cubit<FindUsersState> {
  final FindUsersRepository _findUsersRepository;

  FindUsersCubit(this._findUsersRepository) : super(FindUsersState.initial());

  Future<void> getUsersList() async {
    try {
      final users = await _findUsersRepository.getUsersList();
      if (users != null) {
        emit(state.copyWith(
            status: FindUsersStatus.success,
            users: users,
            filteredUsers: users));
      } else {
        emit(state.copyWith(status: FindUsersStatus.error));
      }
    } catch (e) {
      emit(state.copyWith(status: FindUsersStatus.error));
    }
  }

  void filterUsers(String pattern) {
    emit(state.copyWith(
        status: FindUsersStatus.success,
        filteredUsers: _findUsersRepository.filterUsers(state.users, pattern)));
  }

 String? getConversationID(List<ConversationsListEntry> conversations) {
  return _findUsersRepository.getConversationID(conversations);
 }
}
