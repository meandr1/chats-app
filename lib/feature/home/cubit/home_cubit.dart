import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeState.initial());

  Future<void> addUser() async {
    await _homeRepository.addUser();
  }

  Future<void> addConversations() async {
    await _homeRepository.addConversation();
  }

  Future<void> checkUserProvider({required String uid}) async {
    await _homeRepository.checkUserProvider(uid: uid);
  }

  Future<void> signOut() async {
    await _homeRepository.signOut();
  }
}
