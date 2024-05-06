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

    final usersList = await getUsersList(conversationEntries);
    final messagesList = await getLastMessageList(conversationEntries);
    await markMessagesAsDelivered(conversationEntries);
    final List<int> unreadMessagesCount =
        await getUnreadMessageCount(conversationEntries, currentUID);

    return getConversationLayouts(
        conversationEntries: conversationEntries,
        users: usersList,
        messages: messagesList,
        unreadMessagesCount: unreadMessagesCount);
  }

  Future<List<FirebaseUser?>> getUsersList(
      List<ConversationsListEntry> conversationEntries) async {
    final usersSnapshotList = await Future.wait(conversationEntries.map((e) =>
        _db
            .collection('users')
            .where('__name__', isEqualTo: e.companionID)
            .get()));
    return getUserFromSnapshot(usersSnapshotList, conversationEntries);
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

  Future<List<Message?>> getLastMessageList(
      List<ConversationsListEntry> conversationEntries) async {
    final messagesSnapshotList = await Future.wait(conversationEntries.map(
        (e) => _db
            .collection(e.conversationID)
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get()));
    return getMessageFromSnapshot(messagesSnapshotList);
  }

  List<Message?> getMessageFromSnapshot(
      List<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    return snapshot
        .map((e) =>
            e.docs.isNotEmpty ? Message.fromJSON(e.docs.first.data()) : null)
        .toList();
  }

  Future<void> markMessagesAsDelivered(
      List<ConversationsListEntry> conversationEntries) async {
    final batch = _db.batch();
    final undeliveredMessages = (await Future.wait(conversationEntries.map(
            (e) => _db
                .collection(e.conversationID)
                .where('status', isEqualTo: 'sent')
                .get())))
        .asMap()
        .entries
        .map((e) => {
              conversationEntries[e.key].conversationID: e.value.docs
                  .where((el) =>
                      el.data()['sender'] ==
                      conversationEntries[e.key].companionID)
                  .toList()
            })
        .toList();
    undeliveredMessages.forEach((el) {
      final conversationID = el.keys.first;
      final messages = el.values.first;
      messages.forEach((doc) {
        final docRef = _db.collection(conversationID).doc(doc.id);
        batch.update(docRef, {'status': 'delivered'});
      });
    });
    await batch.commit();
  }

  Future<List<int>> getUnreadMessageCount(
      List<ConversationsListEntry> conversationEntries,
      String currentUID) async {
    final unreadMessagesSnapshot = await Future.wait(conversationEntries.map(
        (e) => _db
            .collection(e.conversationID)
            .where('status', isNotEqualTo: 'read')
            .get()));
    return unreadMessagesSnapshot
        .map((e) => e.docs
            .map((e) => Message.fromJSON(e.data()))
            .where((e) => e.sender != currentUID))
        .map((e) => e.length)
        .toList();
  }

  List<ConversationLayout> getConversationLayouts(
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

  Future<void> deleteConversation(
      {required String companionUID, required String conversationID}) async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    final collection = await _db.collection(conversationID).get();
    await Future.wait([
      _db
          .collection('users')
          .doc(currentUID)
          .update({'conversations.$conversationID': FieldValue.delete()}),
      _db
          .collection('users')
          .doc(companionUID)
          .update({'conversations.$conversationID': FieldValue.delete()})
    ]);
    await Future.wait(collection.docs.map((e) => e.reference.delete()));
  }
}
