part of 'find_users_cubit.dart';

enum FindUsersStatus { initial, error, success }

class FindUsersState extends Equatable {
  final FindUsersStatus status;
  final List<FirebaseUser>? users;
  final List<FirebaseUser>? filteredUsers;
  const FindUsersState({required this.status, this.users, this.filteredUsers});

  @override
  List<Object?> get props => [
        status,
        users,
        filteredUsers,
      ];

  factory FindUsersState.initial() {
    return const FindUsersState(status: FindUsersStatus.initial);
  }

  FindUsersState copyWith(
      {FindUsersStatus? status,
      List<FirebaseUser>? users,
      List<FirebaseUser>? filteredUsers}) {
    return FindUsersState(
        status: status ?? this.status,
        users: users ?? this.users,
        filteredUsers: filteredUsers ?? this.filteredUsers);
  }
}
