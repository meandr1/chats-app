import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:chats/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ConversationLayout>> getConversationLayoutsList(
      List<ConversationsListEntry> conversationEntries) async {
    if (conversationEntries.isEmpty) return [];
    final currentUID = FirebaseAuth.instance.currentUser!.uid;
    final usersSnapshotList = await Future.wait(conversationEntries.map((e) =>
        _db
            .collection('users')
            .where('__name__', isEqualTo: e.companionID)
            .get()));
    final usersList =
        getUserFromSnapshot(usersSnapshotList, conversationEntries);
    final messagesSnapshotList = await Future.wait(conversationEntries.map(
        (e) => _db
            .collection(e.conversationID)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get()));
    final messagesList = getMessageFromSnapshot(messagesSnapshotList);
    final unreadMessagesSnapshot = await Future.wait(conversationEntries.map(
        (e) => _db
            .collection(e.conversationID)
            .where('status', isNotEqualTo: 'read')
            .get()));
    final List<int> unreadMessagesCount = unreadMessagesSnapshot
        .map((e) => e.docs
            .map((e) => Message.fromJSON(e.data()))
            .where((e) => e.sender != currentUID))
        .map((e) => e.length)
        .toList();
    return getConversations(
        conversationEntries: conversationEntries,
        users: usersList,
        messages: messagesList,
        unreadMessagesCount: unreadMessagesCount);
  }

  List<ConversationLayout> getConversations(
      {required List<FirebaseUser?> users,
      required List<ConversationsListEntry> conversationEntries,
      required List<Message?> messages,
      required List<int?> unreadMessagesCount}) {
    final List<ConversationLayout> conversationsList = [];
    messages.asMap().forEach((index, message) {
      if (message != null && users[index] != null) {
        conversationsList.add(ConversationLayout(
            conversationID: conversationEntries[index].conversationID,
            companionID: users[index]!.uid,
            companionName:
                '${users[index]!.userInfo.firstName} ${users[index]!.userInfo.lastName}',
            companionPhotoURL: users[index]!.userInfo.photoURL ?? '',
            lastMessage: message.text,
            timestamp: message.timestamp!,
            unreadMessages: unreadMessagesCount[index] ?? 0));
      }
    });
    return conversationsList;
  }

  List<Message?> getMessageFromSnapshot(
      List<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return snapshot
        .map((e) =>
            e.docs.isNotEmpty ? Message.fromJSON(e.docs.first.data()) : null)
        .toList();
  }

  List<FirebaseUser?> getUserFromSnapshot(
      List<QuerySnapshot<Map<String, dynamic>>> snapshot,
      List<ConversationsListEntry> conversationsList) {
    return snapshot.asMap().entries.map((entry) {
      final index = entry.key;
      return entry.value.docs.isNotEmpty
          ? FirebaseUser.fromJSON(
              jsonData: entry.value.docs.first.data(),
              uid: conversationsList[index].companionID)
          : null;
    }).toList();
  }

  Future<void> deleteConversation({required String companionUID}) async {
    final currentUID = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('users').doc(currentUID).update({
      'conversations.$companionUID': FieldValue.delete(),
    });
  }
}
