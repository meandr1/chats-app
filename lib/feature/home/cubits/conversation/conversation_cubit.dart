import 'package:chats/feature/home/repository/conversation_repository.dart';
import 'package:chats/helpers/custom_print.dart';
import 'package:chats/models/message.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  final ConversationRepository _conversationRepository;

  ConversationCubit(this._conversationRepository)
      : super(ConversationState.initial());

  void sendMessage({required String message, String? conversationID}) {
    conversationID ??= state.conversationID;
    if(conversationID == null){
    emit(state.copyWith(status: ConversationStatus.error));
    }
  printYellow("message: $message");
  printYellow("conversationID: $conversationID");





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
