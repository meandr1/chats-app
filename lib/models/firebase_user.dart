import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/user_info.dart';

class FirebaseUser {
  final String uid;
  final UserInfo userInfo;
  final List<ConversationsListEntry> conversations;

  FirebaseUser(
      {required this.uid, required this.userInfo, required this.conversations});

  factory FirebaseUser.fromJSON(
      {required Map<String, dynamic> jsonData, required String uid}) {
    final userInfo = UserInfo.fromJSON(jsonData['userInfo']);

    Map<String, dynamic>? jsonOfConversations = jsonData['conversations'];
    List<ConversationsListEntry> conversations = [];
    if (jsonOfConversations != null) {
      jsonOfConversations.entries.toList().forEach(
          (entry) => conversations.add(ConversationsListEntry.fromJSON(entry)));
    }
    return FirebaseUser(
        uid: uid, userInfo: userInfo, conversations: conversations);
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
