import 'dart:io';

abstract class IRemoteFilesService {
  Future<File?> getFile({required String firebaseFileUrl});

  Future<String> storeFile(
      {required File file,
      required String fileName,
      required String collectionName});

  Future<void> deleteFile(
      {required String fileName, required String collectionName});
}
