import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUser {
  final String uid;
  final UserInfo userInfo;
  final List<ConversationLayout> conversations;

  FirebaseUser(
      {required this.uid, required this.userInfo, required this.conversations});

  factory FirebaseUser.fromJSON(
      {required Map<String, dynamic> jsonData, required String uid}) {
    final userInfo = UserInfo.fromJSON(jsonData['userInfo']);

    Map<String, dynamic>? jsonOfConversations = jsonData['conversations'];
    List<ConversationLayout> conversations = [];
    if (jsonOfConversations != null) {
      jsonOfConversations.entries.toList().forEach(
          (entry) => conversations.add(ConversationLayout.fromJSON(entry)));
    }
    return FirebaseUser(
        uid: uid, userInfo: userInfo, conversations: conversations);
  }

  factory FirebaseUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    final id = snapshot.id;
    final userInfo = UserInfo.fromJSON(data?['userInfo']);

    Map<String, dynamic>? jsonOfConversations = data?['conversations'];
    List<ConversationLayout> conversations = [];
    if (jsonOfConversations != null) {
      jsonOfConversations.entries.toList().forEach(
          (entry) => conversations.add(ConversationLayout.fromJSON(entry)));
    }
    return FirebaseUser(
        uid: id, userInfo: userInfo, conversations: conversations);
  }

  Map<String, dynamic> toJSON() {
    return {
      uid: {
        'userInfo': userInfo.toJSON(),
        'conversations': {
          conversations.map((element) => element.toJSON()).join(', ')
        }
      }
    };
  }
}
