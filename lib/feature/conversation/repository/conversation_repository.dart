import 'package:chats/app_constants.dart';
import 'package:chats/models/message.dart';
import 'package:chats/services/cache_service/cache_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ConversationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ICacheService _cacheService;

  ConversationRepository(this._cacheService);

  Future<String> addConversation({
    required String companionUID,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final conversationID = const Uuid().v4();
    await Future.wait([
      _db.collection(AppConstants.usersCollection).doc(currentUser!.uid).set({
        AppConstants.conversationsField: {conversationID: companionUID}
      }, SetOptions(merge: true)),
      _db.collection(AppConstants.usersCollection).doc(companionUID).set({
        AppConstants.conversationsField: {conversationID: currentUser.uid}
      }, SetOptions(merge: true))
    ]);
    return conversationID;
  }

  Future<void> sendMessage(
      {required String text,
      required String conversationID,
      required String type}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final Message message = Message(
        sender: currentUser!.uid,
        text: text,
        type: type,
        status: AppConstants.messageSentStatus);
    await _db.collection(conversationID).add(message.toJSON());
  }

  Future<void> markMessagesAsRead(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> messagesList,
      String conversationID) async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    final batch = _db.batch();
    messagesList
        .where((el) =>
            el.data()[AppConstants.messageSenderField] != currentUID &&
            el.data()[AppConstants.messageStatusField] !=
                AppConstants.messageReadStatus)
        .forEach((doc) {
      final docRef = _db.collection(conversationID).doc(doc.id);
      batch.update(docRef,
          {AppConstants.messageStatusField: AppConstants.messageReadStatus});
    });
    await batch.commit();
  }

  Future<void> updateMessagesCache(
      List<Message> messages, String conversationID) async {
    await _cacheService.storeConversationMessages(messages, conversationID);
  }

  List<Message>? getMessagesFromCache(String? conversationID) {
    return _cacheService.getConversationMessages(conversationID);
  }
}
