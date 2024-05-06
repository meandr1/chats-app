import 'package:chats/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ConversationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> addConversation({
    required String companionUID,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final conversationID = const Uuid().v4();
    await Future.wait([
      _db.collection('users').doc(currentUser!.uid).set({
        'conversations': {conversationID: companionUID}
      }, SetOptions(merge: true)),
      _db.collection('users').doc(companionUID).set({
        'conversations': {conversationID: currentUser.uid}
      }, SetOptions(merge: true))
    ]);
    return conversationID;
  }

  Future<Message> sendMessage(
      {required String text, required String conversationID}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final Message message =
        Message(sender: currentUser!.uid, text: text, status: 'sent');
    final messageRef =
        await _db.collection(conversationID).add(message.toJSON());
    return Message.fromJSON((await messageRef.get()).data()!);
  }

  Future<List<Message?>> getConversationMessages(
      {required String conversationID}) async {
    final messagesList =
        (await _db.collection(conversationID).orderBy('timestamp').get()).docs;
    if (messagesList.isNotEmpty) {
      markMessagesAsRead(messagesList, conversationID);
      return messagesList.map((e) => Message.fromJSON(e.data())).toList();
    }
    return [];
  }

  Future<void> markMessagesAsRead(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> messagesList,
      String conversationID) async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    final batch = _db.batch();
    messagesList
        .where((el) =>
            el.data()['sender'] != currentUID && el.data()['status'] != 'read')
        .forEach((doc) {
      final docRef = _db.collection(conversationID).doc(doc.id);
      batch.update(docRef, {'status': 'read'});
    });
    await batch.commit();
  }
}
