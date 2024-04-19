part of 'chats_cubit.dart';

enum ChatsStatus { initial, conversationsLoaded, error }

class ChatsState extends Equatable {
  final ChatsStatus status;
  final List<ConversationLayout>? conversations;

  const ChatsState({required this.status, this.conversations});

  @override
  List<Object?> get props => [status, conversations];

  factory ChatsState.initial() {
    return const ChatsState(status: ChatsStatus.initial);
  }

  ChatsState copyWith(
      {ChatsStatus? status, List<ConversationLayout>? conversations}) {
    return ChatsState(
        status: status ?? this.status,
        conversations: conversations ?? this.conversations);
  }
}
