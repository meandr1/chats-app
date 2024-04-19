class ConversationLayout {
  String companionUID;
  String companionName;
  String? companionPhotoURL;
  String lastMessage;
  int? unreadMessages;
  int? timestamp;
  ConversationLayout(
      {required this.companionUID,
      required this.companionName,
      this.companionPhotoURL,
      required this.lastMessage,
      this.unreadMessages,
      this.timestamp});

  factory ConversationLayout.fromJSON(MapEntry<String, dynamic> jsonData) {
    final String companionUID = jsonData.key;
    final Map<String, dynamic> conversationData = jsonData.value;
    return ConversationLayout(
        companionUID: companionUID,
        companionName: conversationData['companionName'],
        companionPhotoURL: conversationData['companionPhotoURL'],
        lastMessage: conversationData['lastMessage'],
        unreadMessages: conversationData['unreadMessages'],
        timestamp: conversationData['timestamp']);
  }

  Map<String, Map<String, dynamic>> toJSON() {
    return {
      companionUID: {
        "companionName": companionName,
        "companionPhotoURL": companionPhotoURL,
        "lastMessage": lastMessage,
        "timestamp": DateTime.now().microsecondsSinceEpoch,
        "unreadMessages": unreadMessages ?? 0,
      }
    };
  }
}
