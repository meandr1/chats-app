import 'package:chats/hive_boxes.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/message.dart';
import 'package:chats/services/cache_service/cache_service_interface.dart';

class CacheService implements ICacheService {
  @override
  List<Message>? getConversationMessages(String? conversationID) {
    if (conversationID == null) return null;
    return messageBox.get(conversationID)?.cast<Message>();
  }

  @override
  List<ConversationLayout>? getConversations(String? currentUID) {
    if (currentUID == null) return null;
    return conversationLayoutBox.get(currentUID)?.cast<ConversationLayout>();
  }

  @override
  Future<void> storeConversationMessages(
      List<Message> messages, String conversationID) async {
    await messageBox.put(conversationID, messages);
  }

  @override
  Future<void> storeConversations(
      List<ConversationLayout> conversations, String currentUID) async {
    await conversationLayoutBox.put(currentUID, conversations);
  }
}
