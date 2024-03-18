import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/model/firebase_user.dart';

class HomeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await _db.collection('users').doc(user!.uid).set(
          FirebaseUser.updateUserInfo(
              firstName: user.displayName,
              email: user.email,
              phoneNumber: user.phoneNumber,
              photoURL: user.photoURL,
              lastName: ''),
          SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

    Future<void> addUserIfNotExists() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final DocumentSnapshot result = await _db.collection('users').doc(user!.uid).get();
      if (!result.exists) {
        addUser();
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }


  Future<void> addConversations() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await _db.collection('users').doc(user!.uid).set(
          FirebaseUser.updateConversation(
              chattingWithUID: 'sssssssssssssfkljhvsfl',
              name: 'john',
              lastMessage: 'asfds ef e ef efefef sfsdff'),
          SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
