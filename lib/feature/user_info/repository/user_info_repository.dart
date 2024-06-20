import 'dart:io';
import 'package:chats/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/models/user_info.dart' as user_info;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class UserInfoRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> updateUserInfo(
      {required String currentUID,
      String? newFirstName,
      String? newLastName,
      String? newEmail,
      String? provider,
      String? newPhotoURL,
      String? newPhoneNumber}) async {
    await _db.collection(AppConstants.usersCollection).doc(currentUID).set({
      AppConstants.userInfoField: user_info.UserInfo(
              firstName: newFirstName,
              lastName: newLastName,
              email: newEmail,
              provider: provider,
              photoURL: newPhotoURL,
              phoneNumber:
                  newPhoneNumber != null ? '+380$newPhoneNumber' : null)
          .toJSON()
    }, SetOptions(merge: true));
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<String?> uploadImage() async {
    final imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final file = File(image.path);
      final newName = generateFileName(file.path);
      final snapshot = await _firebaseStorage
          .ref()
          .child('${AppConstants.userAvatarsCollection}/$newName')
          .putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } else {
      return null;
    }
  }

  Future<void> deleteOldImage(String imgURL) async {
    final fileName = getFileNameFromURL(imgURL);
    await _firebaseStorage
        .ref()
        .child('${AppConstants.userAvatarsCollection}/$fileName')
        .delete();
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
    return imgURL.substring(
        imgURL.lastIndexOf('%2F') + '%2F'.length, imgURL.indexOf('?'));
  }
}
