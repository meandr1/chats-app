import 'package:chats/app_constants.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/models/firebase_user.dart' as firebase_user;

class FindUsersRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<firebase_user.FirebaseUser>?> getUsersList() async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;

    final result = await _db.collection(AppConstants.usersCollection).get();
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
    return null;
  }

  List<firebase_user.FirebaseUser> filterUsers(
      List<firebase_user.FirebaseUser>? users, String pattern) {
    pattern =
        pattern.trim().replaceAll(RegExp(r' +'), ' ').split(' ').join(')(?=.*');
    List<firebase_user.FirebaseUser> filtered = [];
    if (users != null) {
      filtered.addAll(users.where((user) {
        final matcher = RegExp('(?=.*$pattern)', caseSensitive: false);
        final test = '${user.userInfo.firstName} ${user.userInfo.lastName}';
        return matcher.hasMatch(test);
      }));
    }
    return filtered;
  }

  String? getConversationID(List<ConversationsListEntry> conversations) {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    for (var conversation in conversations) {
      if (conversation.companionID == currentUID) {
        return conversation.conversationID;
      }
    }
    return null;
  }
}
