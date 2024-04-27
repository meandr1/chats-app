class ConversationsListEntry {
  String companionID;
  String conversationID;
  ConversationsListEntry(
      {required this.companionID, required this.conversationID});

  factory ConversationsListEntry.fromJSON(MapEntry<String, dynamic> jsonData) {
    final String conversationID = jsonData.key;
    final String companionID = jsonData.value;
    return ConversationsListEntry(
        companionID: companionID, conversationID: conversationID);
  }

  Map<String, String> toJSON() {
    return {conversationID: companionID};
  }
}

class ConversationLayout {
  String conversationID;
  String companionID;
  String companionName;
  String? companionPhotoURL;
  String? lastMessage;
  int unreadMessages;
  int timestamp;
  ConversationLayout(
      {required this.companionID,
      required this.conversationID,
      required this.companionName,
      this.companionPhotoURL,
      this.lastMessage,
      required this.unreadMessages,
      required this.timestamp});
}
