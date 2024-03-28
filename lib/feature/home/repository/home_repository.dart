import 'package:chats/helpers/custom_print.dart';
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
                photoURL: user.photoURL)
            .toJSON()
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      printYellow(e.message);
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
      printYellow(e.message);
    }
  }

  Future<firebase_user.FirebaseUser?> getUserByUID(
      {required String uid}) async {
    try {
      final QuerySnapshot result =
          await _db.collection('users').where('__name__', isEqualTo: uid).get();
      final docs = result.docs;
      if (docs.isNotEmpty) {
        final userJson = docs[0].data() as Map<String, dynamic>;
        final user =
            firebase_user.FirebaseUser.fromJSON(jsonData: userJson, uid: uid);
        return user;
      }
    } on FirebaseAuthException catch (e) {
      printYellow(e.message);
    }
    return null;
  }

  Future<List<firebase_user.FirebaseUser>?> getUsersList() async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    try {
      final result = await _db.collection('users').get();
      final docs = result.docs;
      if (docs.isNotEmpty) {
        final usersList = docs
            .map((e) => firebase_user.FirebaseUser.fromJSON(
                jsonData: e.data(), uid: e.id))
            .toList();
        return usersList
            .where((user) =>
                user.uid != currentUID &&
                user.userInfo.firstName != null &&
                user.userInfo.lastName != null)
            .toList();
      }
    } on FirebaseAuthException catch (e) {
      printYellow(e.message);
    }
    return null;
  }

  List<firebase_user.FirebaseUser> filterUsers(
      List<firebase_user.FirebaseUser>? users, String pattern) {
    pattern =
        pattern.trim().replaceAll(RegExp(r' +'), ' ').split(' ').join(')(?=.*');
    List<firebase_user.FirebaseUser>? sorted = [];
    if (users != null) {
      sorted.addAll(users.where((user) {
        final matcher = RegExp('(?=.*$pattern)', caseSensitive: false);
        final test = '${user.userInfo.firstName} ${user.userInfo.lastName}';
        return matcher.hasMatch(test);
      }));
    }
    return sorted;
  }

  Future<String?> checkUserProvider({required String uid}) async {
    firebase_user.FirebaseUser? user = await getUserByUID(uid: uid);
    if (user != null) {
      return user.userInfo.provider;
    }
    return null;
  }

  Future<void> addConversation() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      await _db.collection('users').doc(user!.uid).set({
        'conversations': firebase_user.Conversation(
                companionUID: 'qqqqqqqkljhvsfl',
                companionName: 'johnqqqq',
                lastMessage: 'asfds ef e ef efefef sfsdff')
            .toJSON()
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      printYellow(e.message);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
