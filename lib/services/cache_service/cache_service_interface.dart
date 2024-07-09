import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/message.dart';

abstract class ICacheService {
  Future<void> storeConversations(List<ConversationLayout> conversations, String currentUID);
  Future<void> storeConversationMessages(List<Message> messages, String conversationID);

  List<ConversationLayout>? getConversations(String? currentUID);
  List<Message>? getConversationMessages(String? conversationID);
}
