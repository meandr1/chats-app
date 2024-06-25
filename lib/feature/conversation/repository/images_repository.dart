import 'dart:io';
import 'package:chats/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class ImagesRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      return result.files.single.path!;
    }
    return null;
  }

  Future<bool> getPermission() async {
    await Permission.photos.request();
    final permissionStatus = await Permission.photos.status;
    return permissionStatus == PermissionStatus.granted ||
        permissionStatus == PermissionStatus.limited;
  }

  Future<String?> uploadImage(String? path) async {
    if (path != null) {
      final file = File(path);
      final newName = '${const Uuid().v4()}.${path.split('.').last}';
      final snapshot = await _firebaseStorage
          .ref()
          .child('${AppConstants.userImagesCollection}/$newName')
          .putFile(file);
      return await snapshot.ref.getDownloadURL();
    } else {
      return null;
    }
  }
}
