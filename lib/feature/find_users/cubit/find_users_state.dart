part of 'find_users_cubit.dart';

enum FindUsersStatus { initial, error, success, conversationAdded }

class FindUsersState extends Equatable {
  final FindUsersStatus status;
  final List<FirebaseUser>? users;
  final ConversationsListEntry? newConversationEntry;
  final List<FirebaseUser>? filteredUsers;
  const FindUsersState(
      {this.newConversationEntry,
      required this.status,
      this.users,
      this.filteredUsers});

  @override
  List<Object?> get props => [
        status,
        users,
        newConversationEntry,
        filteredUsers,
      ];

  factory FindUsersState.initial() {
    return const FindUsersState(status: FindUsersStatus.initial);
  }

  FindUsersState copyWith(
      {FindUsersStatus? status,
      List<FirebaseUser>? users,
      ConversationsListEntry? newConversationEntry,
      List<FirebaseUser>? filteredUsers}) {
    return FindUsersState(
        status: status ?? this.status,
        newConversationEntry: newConversationEntry ?? this.newConversationEntry,
        users: users ?? this.users,
        filteredUsers: filteredUsers ?? this.filteredUsers);
  }
}
