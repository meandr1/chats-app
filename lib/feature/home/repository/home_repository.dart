import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/model/firebase_user.dart' as firebase_user;

class HomeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser({String? provider}) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await _db.collection('users').doc(user!.uid).set({
        'userInfo': firebase_user.UserInfo(
                provider: provider,
                firstName: user.displayName,
                email: user.email,
                phoneNumber: user.phoneNumber,
                photoURL: user.photoURL,
                lastName: '')
            .toJSON()
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> addUserIfNotExists({String? provider}) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      final DocumentSnapshot result =
          await _db.collection('users').doc(user!.uid).get();
      if (!result.exists) {
        addUser(provider: provider);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<firebase_user.FirebaseUser?> getUserByUID({required String uid}) async {
    try {
      final QuerySnapshot result =
          await _db.collection('users').where('__name__', isEqualTo: uid).get();
      final docs = result.docs;
      if (docs.isNotEmpty){
      final userJson = result.docs[0].data() as Map<String,dynamic>;
      final user = firebase_user.FirebaseUser.fromJSON(userJson);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
      return null;
  }


  Future<void> checkUserProvider({required String uid}) async {
    try {
      await getUserByUID(uid: uid);
      final QuerySnapshot result =
          await _db.collection('users').where('__name__', isEqualTo: uid).get();
      final res = result.docs[0].data() as Map;
      // print(res['userInfo']);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> addConversation() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await _db.collection('users').doc(user!.uid).set({
        'conversations':
          firebase_user.Conversation(
                  companionUID: 'fffffffffffkljhvsfl',
                  companionName: 'john',
                  lastMessage: 'asfds ef e ef efefef sfsdff')
              .toJSON()},
          SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
