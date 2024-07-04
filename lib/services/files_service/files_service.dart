import 'dart:async';
import 'dart:io';
import 'package:chats/services/files_service/interface/files_service_interface.dart';
import 'package:chats/services/files_service/interface/local_files_service_interface.dart';
import 'package:chats/services/files_service/interface/remote_files_service_interface.dart';
import 'package:uuid/uuid.dart';

class FilesService implements IFilesService {
  final ILocalFilesService localFilesService;
  final IRemoteFilesService remoteFilesService;

  FilesService(
      {required this.localFilesService, required this.remoteFilesService});

  @override
  FutureOr<File?> getFile({required String firebaseFileUrl}) async {
    try {
      final fileName = getFileNameFromURL(firebaseFileUrl);
      final localFile = localFilesService.getFile(fileName: fileName);
      if (localFile != null) return localFile;
      final remoteFile =
          await remoteFilesService.getFile(firebaseFileUrl: firebaseFileUrl);
      localFilesService.storeFile(file: remoteFile!, fileName: fileName);
      return remoteFile;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> storeFile(
      {required File file, required String collectionName}) async {
    final name = generateFileName(file.path);
    localFilesService.storeFile(file: file, fileName: name);
    final firebaseFileUrl = await remoteFilesService.storeFile(
        file: file, fileName: name, collectionName: collectionName);
    return firebaseFileUrl;
  }

  @override
  Future<void> deleteFile(
      {required String fileURL, required String collectionName}) async {
    final fileName = getFileNameFromURL(fileURL);
    await localFilesService.deleteFile(fileName: fileName);
    await remoteFilesService.deleteFile(
        fileName: fileName, collectionName: collectionName);
  }

  String generateFileName(String filePath) {
    final extension = filePath.split('.').last;
    final name = const Uuid().v4();
    return '$name.$extension';
  }

  String getFileNameFromURL(String fileURL) {
    return fileURL.substring(
        fileURL.lastIndexOf('%2F') + '%2F'.length, fileURL.indexOf('?'));
  }
}
