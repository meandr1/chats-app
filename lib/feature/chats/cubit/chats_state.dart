part of 'chats_cubit.dart';

enum ChatsStatus { initial, conversationsLoaded, error }

class ChatsState extends Equatable {
  final ChatsStatus status;
  final List<ConversationsListEntry>? conversationEntries;
  final List<ConversationLayout>? conversations;

  const ChatsState({required this.status, this.conversationEntries, this.conversations});

  @override
  List<Object?> get props => [status, conversationEntries, conversations];

  factory ChatsState.initial() {
    return const ChatsState(status: ChatsStatus.initial);
  }

  ChatsState copyWith(
      {ChatsStatus? status, List<ConversationsListEntry>? conversationEntries, List<ConversationLayout>? conversations}) {
    return ChatsState(
        status: status ?? this.status,
        conversations: conversations ?? this.conversations,
        conversationEntries: conversationEntries ?? this.conversationEntries);
  }
}
