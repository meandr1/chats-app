import 'dart:io';
import 'package:chats/hive_boxes.dart';
import 'package:chats/services/files_service/interface/local_files_service_interface.dart';
import 'package:path_provider/path_provider.dart';

class LocalFilesService implements ILocalFilesService {
  @override
  File? getFile({required String fileName}) {
    final path = filesBox.get(fileName);
    if (path == null) return null;
    return File(path);
  }

  @override
  Future<void> storeFile({required File file, required String fileName}) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final destPath = '${appDocumentsDir.path}/$fileName';
    await file.copy(destPath);
    await filesBox.put(fileName, destPath);
  }

  @override
  Future<void> deleteFile({required String fileName}) async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final path = '${appDocumentsDir.path}/$fileName';
    final file = File(path);
    if (await file.exists()) await file.delete();
    await filesBox.delete(fileName);
  }
}
