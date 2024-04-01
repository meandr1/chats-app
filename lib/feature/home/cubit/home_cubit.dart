import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/model/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeState.initial());

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

  Future<void> getMyInfo() async {
    final currentUser = await _homeRepository.getMyInfo();
    if (currentUser != null) {
      emit(state.copyWith(
          status: HomeStatus.success, currentUser: currentUser));
    } else {
      emit(state.copyWith(status: HomeStatus.error));
    }
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
}
