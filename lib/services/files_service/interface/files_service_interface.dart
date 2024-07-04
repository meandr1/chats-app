import 'dart:async';
import 'dart:io';

abstract class IFilesService {
  FutureOr<File?> getFile({required String firebaseFileUrl});

  Future<String> storeFile(
      {required File file, required String collectionName});

  Future<void> deleteFile(
      {required String fileURL, required String collectionName});
}
