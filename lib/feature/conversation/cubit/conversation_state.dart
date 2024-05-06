part of 'conversation_cubit.dart';

enum ConversationStatus { initial, messagesLoaded, error }

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<Message?>? messages;
  final String? companionID;
  final String? conversationID;
  final String? companionName;
  final String? companionPhotoURL;

  const ConversationState(
      {required this.status,
      this.messages,
      this.companionID,
      this.conversationID,
      this.companionName,
      this.companionPhotoURL});

  @override
  List<Object?> get props => [
        status,
        messages,
        companionID,
        conversationID,
        companionName,
        companionPhotoURL
      ];

  factory ConversationState.initial() {
    return const ConversationState(status: ConversationStatus.initial);
  }

  ConversationState copyWith({
    ConversationStatus? status,
    List<Message?>? messages,
    String? companionID,
    String? conversationID,
    String? companionName,
    String? companionPhotoURL,
  }) {
    return ConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      companionID: companionID ?? this.companionID,
      conversationID: conversationID ?? this.conversationID,
      companionName: companionName ?? this.companionName,
      companionPhotoURL: companionPhotoURL ?? this.companionPhotoURL,
    );
  }
}
