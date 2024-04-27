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

  Future<void> sendMessage(String message, String conversationID) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    await _db.collection(conversationID).add(Message(
            sender: currentUser!.uid,
            text: message,
            status: 'sent')
        .toJSON());
  }
}
