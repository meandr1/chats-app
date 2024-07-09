import 'package:chats/app_constants.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:chats/models/message.dart';
import 'package:chats/services/cache_service/cache_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ICacheService _cacheService;

  ChatsRepository(this._cacheService);

  Future<List<FirebaseUser>> getUsersList(
      List<ConversationsListEntry> conversationEntries) async {
    final usersSnapshotList = await Future.wait(conversationEntries.map((e) =>
        _db
            .collection(AppConstants.usersCollection)
            .where('__name__', isEqualTo: e.companionID)
            .get()));
    return getUserFromSnapshot(usersSnapshotList, conversationEntries);
  }

  List<FirebaseUser> getUserFromSnapshot(
      List<QuerySnapshot<Map<String, dynamic>>> snapshot,
      List<ConversationsListEntry> conversationsList) {
    return snapshot.asMap().entries.map((entry) {
      final index = entry.key;
      return FirebaseUser.fromJSON(
          jsonData: entry.value.docs.first.data(),
          uid: conversationsList[index].companionID);
    }).toList();
  }

  Future<void> markMessagesAsDelivered(
      ConversationsListEntry conversationEntry) async {
    final batch = _db.batch();
    final undeliveredMessages = (await _db
            .collection(conversationEntry.conversationID)
            .where(AppConstants.messageStatusField,
                isEqualTo: AppConstants.messageSentStatus)
            .get())
        .docs
        .where((el) =>
            el.data()[AppConstants.messageSenderField] ==
            conversationEntry.companionID)
        .toList();
    for (var doc in undeliveredMessages) {
      final docRef =
          _db.collection(conversationEntry.conversationID).doc(doc.id);
      batch.update(docRef, {
        AppConstants.messageStatusField: AppConstants.messageDeliveredStatus
      });
    }
    await batch.commit();
  }

  Future<int> getUnreadMessageCount(
      {required String conversationID, required String currentUID}) async {
    final unreadMessagesSnapshot = await _db
        .collection(conversationID)
        .where(AppConstants.messageStatusField,
            isNotEqualTo: AppConstants.messageReadStatus)
        .get();
    return unreadMessagesSnapshot.docs
        .map((e) => Message.fromJSON(e.data()))
        .where((e) => e.sender != currentUID)
        .length;
  }

  ConversationLayout getConversationLayout(
      {required FirebaseUser user,
      required ConversationsListEntry conversationEntry,
      required Message message,
      required int unreadMessagesCount}) {
    return ConversationLayout(
        conversationID: conversationEntry.conversationID,
        companionID: user.uid,
        companionName: '${user.userInfo.firstName} ${user.userInfo.lastName}',
        companionPhotoURL: user.userInfo.photoURL ?? '',
        lastMessage: message.text,
        messageType: message.type,
        timestamp: message.timestamp,
        unreadMessages: unreadMessagesCount);
  }

  Future<void> deleteConversation(
      {required String companionUID, required String conversationID}) async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    final collection = await _db.collection(conversationID).get();
    await Future.wait([
      _db.collection(AppConstants.usersCollection).doc(currentUID).update({
        '${AppConstants.conversationsField}.$conversationID':
            FieldValue.delete()
      }),
      _db.collection(AppConstants.usersCollection).doc(companionUID).update({
        '${AppConstants.conversationsField}.$conversationID':
            FieldValue.delete()
      })
    ]);
    await Future.wait(collection.docs.map((e) => e.reference.delete()));
  }

  Future<void> updateConversationsCache(
      List<ConversationLayout> conversations, String currentUID) async {
    await _cacheService.storeConversations(conversations, currentUID);
  }

  List<ConversationLayout>? getConversationsFromCache(String? currentUID) {
    return _cacheService.getConversations(currentUID);
  }
}
