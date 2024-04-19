part of 'conversation_cubit.dart';

enum ConversationStatus { initial, conversationLoaded, error }

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List? messages;

  const ConversationState({required this.status, this.messages});

  @override
  List<Object?> get props => [status, messages];

  factory ConversationState.initial() {
    return const ConversationState(status: ConversationStatus.initial);
  }

  ConversationState copyWith({ConversationStatus? status, List? messages}) {
    return ConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
    );
  }
}
