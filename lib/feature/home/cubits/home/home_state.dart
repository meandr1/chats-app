part of 'home_cubit.dart';

enum HomeStatus { initial, userLoaded, error, fillProfileNeeded, success }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<FirebaseUser>? users;
  final List<FirebaseUser>? filteredUsers;
  final FirebaseUser? currentUser;
  const HomeState(
      {required this.status, this.users, this.currentUser, this.filteredUsers});

  @override
  List<Object?> get props => [
        status,
        users,
        currentUser,
        filteredUsers,
      ];

  factory HomeState.initial() {
    return const HomeState(status: HomeStatus.initial);
  }

  HomeState copyWith(
      {HomeStatus? status,
      List<FirebaseUser>? users,
      List<FirebaseUser>? filteredUsers,
      FirebaseUser? currentUser}) {
    return HomeState(
      status: status ?? this.status,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
