import 'package:chats/helpers/custom_print.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/model/firebase_user.dart' as firebase_user;

class FindUsersRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
    List<firebase_user.FirebaseUser> sorted = [];
    if (users != null) {
      sorted.addAll(users.where((user) {
        final matcher = RegExp('(?=.*$pattern)', caseSensitive: false);
        final test = '${user.userInfo.firstName} ${user.userInfo.lastName}';
        return matcher.hasMatch(test);
      }));
    }
    return sorted;
  }

  Future<bool?> addConversationIfNotExists(
      {required String companionUID,
      required String companionName,
      required String companionPhotoURL}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool? conversationExist = await checkConversationExisting(
        currentUser: currentUser!, companionUID: companionUID);
    if (conversationExist == null) return null;
    if (!conversationExist) {
      try {
        await _db.collection('users').doc(currentUser.uid).set({
          'conversations': firebase_user.Conversation(
                  companionUID: companionUID,
                  companionPhotoURL: companionPhotoURL,
                  companionName: companionName,
                  lastMessage: '')
              .toJSON()
        }, SetOptions(merge: true));
        return true;
      } catch (e) {
        return null;
      }
    }
    return false;
  }

  Future<bool?> checkConversationExisting(
      {required User currentUser, required String companionUID}) async {
    try {
      final res = await _db.collection('users').doc(currentUser.uid).get();
      final mapOfConversations =
          res.data()?['conversations'] as Map<String, dynamic>;
      return mapOfConversations.keys.toList().contains(companionUID);
    } catch (e) {
      return null;
    }
  }
}