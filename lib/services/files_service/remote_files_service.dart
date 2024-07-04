import 'dart:io';
import 'package:chats/services/files_service/interface/remote_files_service_interface.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class RemoteFilesService implements IRemoteFilesService {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<File?> getFile({required String firebaseFileUrl}) async {
    try {
      return await DefaultCacheManager().getSingleFile(firebaseFileUrl);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> storeFile(
      {required File file,
      required String fileName,
      required String collectionName}) async {
    final snapshot = await _firebaseStorage
        .ref()
        .child('$collectionName/$fileName')
        .putFile(file);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> deleteFile(
      {required String fileName, required String collectionName}) async {
    await _firebaseStorage.ref().child('$collectionName/$fileName').delete();
  }
}
