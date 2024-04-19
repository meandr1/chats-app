
import 'package:chats/feature/home/repository/home_repository.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _homeRepository;

  HomeCubit(this._homeRepository) : super(HomeState.initial());

  Future<void> getCurrentUserInfo() async {
    final currentUser = await _homeRepository.getCurrentUserInfo();
    if (currentUser != null) {
      emit(state.copyWith(
          status: isFillPersonalDataNeeded(currentUser)
              ? HomeStatus.fillProfileNeeded
              : HomeStatus.userLoaded,
          currentUser: currentUser));
    } else {
      emit(state.copyWith(status: HomeStatus.error));
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
      {required String provider, required String uid}) async {
    await _homeRepository.addUserIfNotExists(provider: provider, uid: uid);
  }
}
