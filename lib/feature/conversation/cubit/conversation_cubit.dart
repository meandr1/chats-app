import 'dart:async';
import 'package:chats/app_constants.dart';
import 'package:chats/feature/conversation/repository/conversation_repository.dart';
import 'package:chats/models/message.dart';
import 'package:chats/models/screens_args_transfer_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      await _conversationRepository.sendMessage(
          text: text, conversationID: conversationID);
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error));
    }
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      getConversationMessages({String? newConversationID}) {
    final conversationID = newConversationID ?? state.conversationID!;
    return FirebaseFirestore.instance
        .collection(state.conversationID!)
        .orderBy(AppConstants.messageTimestampField)
        .snapshots()
        .listen((event) {
      final messagesSnapshot = event.docs;
      if (messagesSnapshot.isNotEmpty) {
        _conversationRepository.markMessagesAsRead(
            messagesSnapshot, conversationID);
        final messages =
            messagesSnapshot.map((e) => Message.fromJSON(e.data())).toList();
        emit(state.copyWith(
            conversationID: conversationID,
            messages: messages,
            status: ConversationStatus.messagesLoaded));
      }
    },
            onError: (err) => emit(state.copyWith(
                status: ConversationStatus.error, errorText: err)));
  }

  Future<void> addConversation({String? companionID}) async {
    try {
      if (companionID == null) throw Exception();
      final conversationID = await _conversationRepository.addConversation(
          companionUID: companionID);
      getConversationMessages(newConversationID: conversationID);
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error));
    }
  }

  void setState({ChatsScreenArgsTransferObject? args}) {
    emit(state.copyWith(
        companionID: args?.companionID,
        conversationID: args?.conversationID,
        companionName: args?.companionName,
        companionPhotoURL: args?.companionPhotoURL,
        status: ConversationStatus.initial));
  }

  void initState() {
    emit(ConversationState.initial());
  }
}