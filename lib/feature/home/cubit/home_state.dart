part of 'home_cubit.dart';

enum HomeStatus { initial, success, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<FirebaseUser>? users;
  final List<FirebaseUser>? filteredUsers;
  final List<Conversation>? conversations;
  const HomeState({required this.status, this.users, this.conversations, this.filteredUsers});

  @override
  List<Object?> get props => [status, users, conversations, filteredUsers];

  factory HomeState.initial() {
    return const HomeState(status: HomeStatus.initial);
  }

  HomeState copyWith(
      {HomeStatus? status,
      List<FirebaseUser>? users,
      List<FirebaseUser>? filteredUsers,
      List<Conversation>? conversations}) {
    return HomeState(
      status: status ?? this.status,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      conversations: conversations ?? this.conversations,
    );
  }
}
