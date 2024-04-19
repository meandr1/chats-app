import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatsRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> deleteConversation({required String companionUID}) async {
    final currentUID = FirebaseAuth.instance.currentUser!.uid;
    await _db.collection('users').doc(currentUID).update({
      'conversations.$companionUID': FieldValue.delete(),
    });
  }
}
