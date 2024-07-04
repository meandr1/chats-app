import 'dart:io' show File;
import 'package:chats/app_constants.dart';
import 'package:chats/services/files_service/interface/files_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/models/firebase_user.dart' as firebase_user;
import 'package:chats/models/user_info.dart' as user_info;

class HomeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final IFilesService _filesService;

  HomeRepository(this._filesService);

  Future<void> addUser({required String provider, required User user}) async {
    await _db.collection(AppConstants.usersCollection).doc(user.uid).set({
      AppConstants.conversationsField: {},
      AppConstants.userInfoField: user_info.UserInfo(
              provider: provider,
              firstName: user.displayName ?? '',
              lastName: user.displayName ?? '',
              email: user.email ?? '',
              phoneNumber: user.phoneNumber ?? '',
              photoURL: user.photoURL ?? '')
          .toJSON()
    }, SetOptions(merge: true));
  }

  Future<void> addUserIfNotExists(
      {required String provider, required User user}) async {
    final DocumentSnapshot result =
        await _db.collection(AppConstants.usersCollection).doc(user.uid).get();
    if (!result.exists) {
      addUser(provider: provider, user: user);
    }
  }

  Future<firebase_user.FirebaseUser?> getUserByID({required String uid}) async {
    final QuerySnapshot result = await _db
        .collection(AppConstants.usersCollection)
        .where('__name__', isEqualTo: uid)
        .get();
    final docs = result.docs;
    if (docs.isNotEmpty) {
      final userJson = docs.first.data() as Map<String, dynamic>;
      final user =
          firebase_user.FirebaseUser.fromJSON(jsonData: userJson, uid: uid);
      return user;
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

  Future<File?> getFile(String fileUrl) async {
    return _filesService.getFile(firebaseFileUrl: fileUrl);
  }
}
