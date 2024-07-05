import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'conversation_layout.g.dart';

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

@HiveType(typeId: 1)
class ConversationLayout {
  @HiveField(0)
  String conversationID;
  @HiveField(1)
  String companionID;
  @HiveField(2)
  String companionName;
  @HiveField(3)
  String? companionPhotoURL;
  @HiveField(4)
  String? lastMessage;
  @HiveField(5)
  String messageType;
  @HiveField(6)
  int? unreadMessages;
  @HiveField(7)
  Timestamp? timestamp;

  ConversationLayout(
      {required this.companionID,
      required this.conversationID,
      required this.companionName,
      required this.messageType,
      this.companionPhotoURL,
      this.lastMessage,
      this.unreadMessages,
      this.timestamp});
}
