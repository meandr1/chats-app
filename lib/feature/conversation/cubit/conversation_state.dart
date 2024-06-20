part of 'conversation_cubit.dart';

enum ConversationStatus { initial, messagesLoaded, error, micPermissionNotGranted }

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<Message?>? messagesList;
  final String message;
  final bool recording;
  final String? companionID;
  final String? conversationID;
  final String? companionName;
  final String? companionPhotoURL;
  final String? errorText;

  const ConversationState(
      {required this.status,
      this.messagesList,
      required this.message,
      required this.recording,
      this.companionID,
      this.conversationID,
      this.companionName,
      this.errorText,
      this.companionPhotoURL});

  @override
  List<Object?> get props => [
        status,
        recording,
        messagesList,
        message,
        companionID,
        conversationID,
        companionName,
        companionPhotoURL,
        errorText
      ];

  factory ConversationState.initial() {
    return const ConversationState(
        status: ConversationStatus.initial, message: '', recording: false);
  }

  ConversationState copyWith({
    ConversationStatus? status,
    List<Message?>? messagesList,
    String? message,
    bool? recording,
    String? companionID,
    String? conversationID,
    String? companionName,
    String? companionPhotoURL,
    String? errorText,
  }) {
    return ConversationState(
      status: status ?? this.status,
      recording: recording ?? this.recording,
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
