part of 'home_cubit.dart';

enum HomeStatus { initial, success, error, fillProfileNeeded }

class HomeState extends Equatable {
  final String? newFirstName;
  final String? newLastName;
  final String? newEmail;
  final String? newPhoneNumber;
  final HomeStatus? status;
  final List<FirebaseUser>? users;
  final List<FirebaseUser>? filteredUsers;
  final FirebaseUser? currentUser;
  const HomeState(
      {this.newFirstName,
      this.newLastName,
      this.newEmail,
      this.newPhoneNumber,
      this.status,
      this.users,
      this.currentUser,
      this.filteredUsers});

  @override
  List<Object?> get props => [
        status,
        users,
        currentUser,
        filteredUsers,
        newEmail,
        newPhoneNumber,
        newFirstName,
        newLastName
      ];

  factory HomeState.initial() {
    return const HomeState(status: HomeStatus.initial);
  }

  HomeState copyWith(
      {HomeStatus? status,
      List<FirebaseUser>? users,
      String? newEmail,
      String? newPhoneNumber,
      String? newFirstName,
      String? newLastName,
      List<FirebaseUser>? filteredUsers,
      FirebaseUser? currentUser}) {
    return HomeState(
      status: status ?? this.status,
      newEmail: newEmail ?? this.newEmail,
      newFirstName: newFirstName ?? this.newFirstName,
      newLastName: newLastName ?? this.newLastName,
      newPhoneNumber: newPhoneNumber ?? this.newPhoneNumber,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
