import 'package:chats/app_constants.dart';
import 'package:chats/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ConversationRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

    Future<bool> getMicPermission() async {
    await Permission.microphone.request();
    final permissionStatus = await Permission.microphone.status;
    return permissionStatus.isGranted;
  }

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

  Future<Message> sendMessage(
      {required String text, required String conversationID, required String type}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final Message message = Message(
        sender: currentUser!.uid,
        text: text,
        type: type,
        status: AppConstants.messageSentStatus);
    final messageRef =
        await _db.collection(conversationID).add(message.toJSON());
    return Message.fromJSON((await messageRef.get()).data()!);
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
}
