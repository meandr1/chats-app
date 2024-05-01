import 'package:chats/feature/conversation/repository/conversation_repository.dart';
import 'package:chats/models/message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ConversationRepository _conversationRepository;

  ConversationCubit(this._conversationRepository)
      : super(ConversationState.initial());

  void sendMessage({required String text, String? conversationID}) async {
    if (text.trim().isEmpty) return;
    conversationID ??= state.conversationID;
    if (conversationID == null) {
      emit(state.copyWith(status: ConversationStatus.error));
      return;
    }
    try {
      final message = await _conversationRepository.sendMessage(
          text: text, conversationID: conversationID);
      emit(state.copyWith(
          messages: [...state.messages!, message],
          status: ConversationStatus.messageSent));
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error));
    }
  }

  void getConversationMessages({required String conversationID}) async {
    try {
      final messages = await _conversationRepository.getConversationMessages(
          conversationID: conversationID);
      emit(state.copyWith(
          messages: messages, status: ConversationStatus.messagesLoaded));
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error));
    }
  }

  Future<void> addConversation({required String companionID}) async {
    try {
      final conversationID = await _conversationRepository.addConversation(
          companionUID: companionID);
      emit(state.copyWith(
          conversationID: conversationID,
          status: ConversationStatus.conversationAdded));
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error));
    }
  }
}
