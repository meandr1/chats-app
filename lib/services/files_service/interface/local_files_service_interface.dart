import 'dart:io';

abstract class ILocalFilesService {
  File? getFile({required String fileName});

  Future<void> storeFile({required File file, required String fileName});

  Future<void> deleteFile({required String fileName});
}
