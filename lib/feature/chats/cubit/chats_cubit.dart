import 'package:chats/feature/chats/repository/chats_repository.dart';
import 'package:chats/models/conversation_layout.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRepository _chatsRepository;
  ChatsCubit(this._chatsRepository) : super(ChatsState.initial());

  void loadChats(List<ConversationsListEntry> conversationsList) async {
    final List<ConversationLayout> conversations =
        await _chatsRepository.getConversationLayoutsList(conversationsList);
    emit(state.copyWith(
        conversations: conversations, status: ChatsStatus.conversationsLoaded));
  }

  Future<void> deleteChat({required companionID}) async {
    emit(state.copyWith(
        conversations: state.conversations!
            .where((el) => el.companionID != companionID)
            .toList(),
        status: ChatsStatus.conversationsLoaded));
    try {
      await _chatsRepository.deleteConversation(companionUID: companionID);
    } catch (e) {
      emit(state.copyWith(status: ChatsStatus.error));
    }
  }
}
