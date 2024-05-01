part of 'conversation_cubit.dart';

enum ConversationStatus { initial, messagesLoaded, messageSent, conversationAdded, error }

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<Message?>? messages;
  final String? companionID;
  final String? conversationID;

  const ConversationState({
    required this.status,
    this.messages,
    this.companionID,
    this.conversationID,
  });

  @override
  List<Object?> get props => [status, messages, companionID, conversationID];

  factory ConversationState.initial() {
    return const ConversationState(
        status: ConversationStatus.initial);
  }

  ConversationState copyWith({
    ConversationStatus? status,
    List<Message?>? messages,
    String? companionID,
    String? conversationID,
  }) {
    return ConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      companionID: companionID ?? this.companionID,
      conversationID: conversationID ?? this.conversationID,
    );
  }
}
