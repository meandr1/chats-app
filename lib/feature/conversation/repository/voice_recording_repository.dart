import 'dart:io' show File;
import 'package:chats/app_constants.dart';
import 'package:chats/services/files_service/interface/files_service_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceRecordingRepository {
  final IFilesService _filesService;

  VoiceRecordingRepository(this._filesService);

  Future<bool> checkMicPermissionStatus() async {
    final permissionStatus = await Permission.microphone.status;
    return permissionStatus != PermissionStatus.denied ||
        permissionStatus != PermissionStatus.permanentlyDenied ||
        permissionStatus != PermissionStatus.restricted;
  }

  Future<bool> getMicPermission() async {
    await Permission.microphone.request();
    return checkMicPermissionStatus();
  }

  Future<String?> uploadVoiceMessage(String? path) async {
    if (path != null) {
      final file = File(path);
      return await _filesService.storeFile(
          file: file, collectionName: AppConstants.userRecordingsCollection);
    } else {
      return null;
    }
  }
}
