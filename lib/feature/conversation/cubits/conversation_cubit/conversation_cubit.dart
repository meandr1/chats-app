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

  void messageTyping(String text) {
    emit(state.copyWith(message: text));
  }

  void cancelMessagesSubscription() {
    state.messagesSubscription?.cancel();
    emit(ConversationState.initial());
  }

  void sendMessage() async {
    if (state.message?.trim().isEmpty ?? true) return;
    if (state.conversationID == null) {
      emit(state.copyWith(status: ConversationStatus.error));
      return;
    }
    try {
      await _conversationRepository.sendMessage(
          text: state.message!.trim(),
          conversationID: state.conversationID!,
          type: AppConstants.textType);
      emit(state.copyWith(message: ''));
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error, message: ''));
    }
  }

  void sendFileMessage({required String fileUrl, required String type}) async {
    try {
      await _conversationRepository.sendMessage(
          text: fileUrl, conversationID: state.conversationID!, type: type);
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error));
    }
  }

  void getConversationMessages() {
    final conversationID = state.conversationID!;
    final cachedMessages =
        _conversationRepository.getMessagesFromCache(conversationID);
    emit(state.copyWith(
        conversationID: conversationID,
        messagesList: cachedMessages,
        status: ConversationStatus.messagesLoaded));
    final messagesSubscription = FirebaseFirestore.instance
        .collection(state.conversationID!)
        .orderBy(AppConstants.messageTimestampField)
        .snapshots()
        .listen((event) async {
      final messagesSnapshot = event.docs;
      final List<Message> messages = [];
      if (messagesSnapshot.isNotEmpty) {
        _conversationRepository.markMessagesAsRead(
            messagesSnapshot, conversationID);
        messages.addAll(
            messagesSnapshot.map((e) => Message.fromJSON(e.data())).toList());
      }
      await _conversationRepository.updateMessagesCache(
          messages, conversationID);
      emit(state.copyWith(
          conversationID: conversationID,
          messagesList: messages,
          status: ConversationStatus.messagesLoaded));
    },
            onError: (err) => emit(state.copyWith(
                status: ConversationStatus.error, errorText: err)));
    emit(state.copyWith(messagesSubscription: messagesSubscription));
  }

  Future<void> addConversation(String? companionID) async {
    try {
      if (companionID == null) throw Exception();
      final conversationID = await _conversationRepository.addConversation(
          companionUID: companionID);
      emit(state.copyWith(conversationID: conversationID));
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error));
    }
  }

  void setState({ChatsScreenArgsTransferObject? args}) async {
    emit(state.copyWith(
        companionID: args?.companionID,
        conversationID: args?.conversationID,
        companionName: args?.companionName,
        companionPhotoURL: args?.companionPhotoURL,
        status: ConversationStatus.initial));
    if (args?.conversationID == null) await addConversation(args?.companionID);
    getConversationMessages();
  }
}
