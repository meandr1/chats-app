part of 'home_cubit.dart';

enum HomeStatus { initial, userLoaded, error, fillProfileNeeded }

class HomeState extends Equatable {
  final String? errorMessage;
  final HomeStatus status;
  final List<FirebaseUser>? users;
  final List<FirebaseUser>? filteredUsers;
  final FirebaseUser? currentUser;
  const HomeState(
      {required this.status,
      this.errorMessage,
      this.users,
      this.currentUser,
      this.filteredUsers});

  @override
  List<Object?> get props => [
        status,
        users,
        errorMessage,
        currentUser,
        filteredUsers,
      ];

  factory HomeState.initial() {
    return const HomeState(status: HomeStatus.initial);
  }

  HomeState copyWith(
      {HomeStatus? status,
      List<FirebaseUser>? users,
      String? errorMessage,
      List<FirebaseUser>? filteredUsers,
      FirebaseUser? currentUser}) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
