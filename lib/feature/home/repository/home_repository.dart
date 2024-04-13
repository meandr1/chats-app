import 'dart:io';
import 'package:chats/helpers/custom_print.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/model/firebase_user.dart' as firebase_user;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class HomeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  Future<void> addUser({String? provider}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      await _db.collection('users').doc(currentUser?.uid).set({
        'userInfo': firebase_user.UserInfo(
                provider: provider ?? 'email',
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

  Future<void> updateUserInfo(
      {required String currentUID,
      String? newFirstName,
      String? newLastName,
      String? newEmail,
      String? provider,
      String? photoURL,
      String? newPhoneNumber}) async {
    await _db.collection('users').doc(currentUID).set({
      'userInfo': firebase_user.UserInfo(
              firstName: newFirstName,
              lastName: newLastName,
              email: newEmail,
              provider: provider,
              photoURL: photoURL,
              phoneNumber:
                  newPhoneNumber != null ? '+380$newPhoneNumber' : null)
          .toJSON()
    }, SetOptions(merge: true));
  }

  Future<void> addUserIfNotExists({String? provider}) async {
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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> uploadImage() async {
    final imagePicker = ImagePicker();
    XFile? image;
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      final newName = generateFileName(file.path);
      final snapshot =
          await _firebaseStorage.ref().child('images/$newName').putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return null;
    }
  }

  Future<void> deleteOldImage(String imgURL) async {
    final fileName = getFileNameFromURL(imgURL);
    await _firebaseStorage.ref().child('images/$fileName').delete();
  }

  Future<bool> getPermission() async {
    await Permission.photos.request();
    final permissionStatus = await Permission.photos.status;
    return permissionStatus.isGranted;
  }

  String generateFileName(String filePath) {
    final extension = filePath.split('.').last;
    final name = const Uuid().v4();
    return '$name.$extension';
  }

  String getFileNameFromURL(String imgURL) {
    return imgURL.substring(imgURL.lastIndexOf('%2F') + 3, imgURL.indexOf('?'));
  }

  // Future<void> addConversation() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   try {
  //     await _db.collection('users').doc(user!.uid).set({
  //       'conversations': firebase_user.Conversation(
  //               companionUID: 'qqqqqqqkljhvsfl',
  //               companionPhotoURL: 'kljzdvdcvzxcvhvsfl',
  //               companionName: 'johnqqqq',
  //               lastMessage: 'asfds ef e ef efefef sfsdff')
  //           .toJSON()
  //     }, SetOptions(merge: true));
  //   } on FirebaseAuthException catch (e) {
  //     printYellow(e.message);
  //   }
  // }

  // Future<String?> checkUserProvider({required String uid}) async {
  //   final user = await getUserByID(uid: uid);
  //   if (user != null) {
  //     return user.userInfo.provider;
  //   }
  //   return null;
  // }
}
