part of 'chats_cubit.dart';

enum ChatsStatus { initial, conversationsLoaded, error }

class ChatsState extends Equatable {
  final ChatsStatus status;
  final String? errorText;
  final List<ConversationsListEntry>? conversationEntries;
  final List<ConversationLayout>? conversations;

  const ChatsState(
      {required this.status,
      this.conversationEntries,
      this.conversations,
      this.errorText});

  @override
  List<Object?> get props =>
      [status, conversationEntries, conversations, errorText];

  factory ChatsState.initial() {
    return const ChatsState(status: ChatsStatus.initial);
  }

  ChatsState copyWith(
      {ChatsStatus? status,
      List<ConversationsListEntry>? conversationEntries,
      List<ConversationLayout>? conversations,
      String? errorText}) {
    return ChatsState(
        status: status ?? this.status,
        errorText: errorText ?? this.errorText,
        conversations: conversations ?? this.conversations,
        conversationEntries: conversationEntries ?? this.conversationEntries);
  }
}
