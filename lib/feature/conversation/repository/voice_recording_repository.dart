import 'dart:io';
import 'package:chats/app_constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class VoiceRecordingRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String?> uploadVoiceMessage(String? path) async {
    if (path != null) {
      final file = File(path);
      final newName = '${const Uuid().v4()}.${path.split('.').last}';
      final snapshot = await _firebaseStorage
          .ref()
          .child('${AppConstants.userRecordingsCollection}/$newName')
          .putFile(file);
      return await snapshot.ref.getDownloadURL();
    } else {
      return null;
    }
  }
}
