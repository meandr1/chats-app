import 'dart:io' show File;
import 'package:chats/app_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gallery_picker/gallery_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class MediaRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> pickFileFromGallery(BuildContext context) async {
    List<MediaFile>? media = await GalleryPicker.pickMedia(
        context: context, singleMedia: true, startWithRecent: true);
    if (media != null && media.isNotEmpty) {
      final file = await media.first.getFile();
      return file.path;
    }
    return null;
  }

  bool? isImage(String? path) {
    if (path == null) return null;
    final mimeType = lookupMimeType(path);
    return mimeType?.startsWith('image');
  }

  Future<String?> takeAPhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image?.path;
  }

  Future<String?> recordAVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickVideo(source: ImageSource.camera);
    return image?.path;
  }

  Future<bool> getPermission() async {
    await Permission.photos.request();
    final permissionStatus = await Permission.photos.status;
    return permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.limited;
  }

  Future<String> uploadImage(
      {required String path, required String type}) async {
    final file = File(path);
    final newName = '${const Uuid().v4()}.${path.split('.').last}';
    final collection = type == AppConstants.imageType
        ? AppConstants.userImagesCollection
        : AppConstants.userVideosCollection;
    final snapshot = await _firebaseStorage
        .ref()
        .child('$collection/$newName')
        .putFile(file);
    return await snapshot.ref.getDownloadURL();
  }
}
