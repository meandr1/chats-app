part of 'conversation_cubit.dart';

enum ConversationStatus { initial, messagesLoaded, error }

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<Message> messagesList;
  final String? message;
  final String? companionID;
  final String? conversationID;
  final String? companionName;
  final String? companionPhotoURL;
  final String? errorText;
  final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      messagesSubscription;

  const ConversationState(
      {required this.status,
      required this.messagesList,
      this.message,
      this.companionID,
      this.conversationID,
      this.companionName,
      this.errorText,
      this.messagesSubscription,
      this.companionPhotoURL});

  @override
  List<Object?> get props => [
        status,
        messagesList,
        message,
        companionID,
        conversationID,
        companionName,
        companionPhotoURL,
        errorText,
        messagesSubscription,
      ];

  factory ConversationState.initial() {
    return const ConversationState(
      status: ConversationStatus.initial,
      messagesList: [],
    );
  }

  ConversationState copyWith(
      {ConversationStatus? status,
      List<Message>? messagesList,
      String? message,
      String? companionID,
      String? conversationID,
      String? companionName,
      String? companionPhotoURL,
      String? errorText,
      StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
          messagesSubscription}) {
    return ConversationState(
      status: status ?? this.status,
      messagesSubscription: messagesSubscription ?? this.messagesSubscription,
      message: message ?? this.message,
      messagesList: messagesList ?? this.messagesList,
      companionID: companionID ?? this.companionID,
      conversationID: conversationID ?? this.conversationID,
      companionName: companionName ?? this.companionName,
      companionPhotoURL: companionPhotoURL ?? this.companionPhotoURL,
      errorText: errorText ?? this.errorText,
    );
  }
}
