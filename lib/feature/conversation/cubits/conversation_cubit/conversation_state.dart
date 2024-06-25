part of 'conversation_cubit.dart';

enum ConversationStatus {
  initial,
  messagesLoaded,
  micPermissionNotGranted,
  error
}

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<Message> messagesList;
  final String message;
  final bool recording;
  final bool voiceMessagePlaying;
  final bool micPermission;
  final String? companionID;
  final String? conversationID;
  final String? companionName;
  final String? companionPhotoURL;
  final String? errorText;

  const ConversationState(
      {required this.status,
      required this.messagesList,
      required this.message,
      required this.recording,
      required this.voiceMessagePlaying,
      required this.micPermission,
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
        voiceMessagePlaying,
        message,
        companionID,
        conversationID,
        companionName,
        companionPhotoURL,
        errorText,
        micPermission
      ];

  factory ConversationState.initial() {
    return const ConversationState(
        status: ConversationStatus.initial,
        messagesList: [],
        message: '',
        recording: false,
        micPermission: false,
        voiceMessagePlaying: false);
  }

  ConversationState copyWith({
    ConversationStatus? status,
    List<Message>? messagesList,
    String? message,
    bool? recording,
    bool? micPermission,
    bool? voiceMessagePlaying,
    String? companionID,
    String? conversationID,
    String? companionName,
    String? companionPhotoURL,
    String? errorText,
  }) {
    return ConversationState(
      status: status ?? this.status,
      micPermission: micPermission ?? this.micPermission,
      recording: recording ?? this.recording,
      voiceMessagePlaying: voiceMessagePlaying ?? this.voiceMessagePlaying,
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
