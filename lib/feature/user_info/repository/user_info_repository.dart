import 'dart:io' show File;
import 'package:chats/app_constants.dart';
import 'package:chats/services/files_service/interface/files_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chats/models/user_info.dart' as user_info;
import 'package:permission_handler/permission_handler.dart';

class UserInfoRepository {
  final IFilesService _filesService;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  UserInfoRepository(this._filesService);

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
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      final file = File(result.files.single.path!);
      final downloadUrl = _filesService.storeFile(
          file: file, collectionName: AppConstants.userAvatarsCollection);
      return downloadUrl;
    } else {
      return null;
    }
  }

  Future<void> deleteOldImage(String fileURL) async {
    _filesService.deleteFile(
        fileURL: fileURL, collectionName: AppConstants.userAvatarsCollection);
  }

  Future<bool> getPermission() async {
    await Permission.photos.request();
    final permissionStatus = await Permission.photos.status;
    return permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.limited;
  }
}
