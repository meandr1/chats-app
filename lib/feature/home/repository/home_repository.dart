import 'package:chats/helpers/custom_print.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/model/firebase_user.dart' as firebase_user;

class HomeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser({required String provider}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      await _db.collection('users').doc(currentUser?.uid).set({
        'userInfo': firebase_user.UserInfo(
                provider: provider,
                firstName: currentUser?.displayName ?? '',
                lastName: currentUser?.displayName ?? '',
                email: currentUser?.email ?? '',
                phoneNumber: currentUser?.phoneNumber ?? '',
                photoURL: currentUser?.photoURL ?? '')
            .toJSON()
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      printYellow(e.message);
    }
  }

  Future<void> addUserIfNotExists(
      {required String provider, required String uid}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      final DocumentSnapshot result =
          await _db.collection('users').doc(currentUser?.uid).get();
      if (!result.exists) {
        addUser(provider: provider);
      }
    } on FirebaseAuthException catch (e) {
      printYellow(e.message);
    }
  }

  Future<firebase_user.FirebaseUser?> getUserByID({required String uid}) async {
    try {
      final QuerySnapshot result =
          await _db.collection('users').where('__name__', isEqualTo: uid).get();
      final docs = result.docs;
      if (docs.isNotEmpty) {
        final userJson = docs.first.data() as Map<String, dynamic>;
        final user =
            firebase_user.FirebaseUser.fromJSON(jsonData: userJson, uid: uid);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      printYellow(e.message);
    }
    return null;
  }

  Future<firebase_user.FirebaseUser?> getCurrentUserInfo() async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    if (currentUID != null) {
      final user = await getUserByID(uid: currentUID);
      if (user != null) {
        return user;
      }
    }
    return null;
  }
}
