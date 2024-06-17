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

  void startRecording() {

    emit(state.copyWith(recording: true, message: ''));
  }

  void stopRecording() {

    emit(state.copyWith(recording: false));
  }

  void recordingCanceled() {
    emit(state.copyWith(recording: false));
  }

  void sendMessage() async {
    if (state.message.trim().isEmpty) return;
    if (state.conversationID == null) {
      emit(state.copyWith(status: ConversationStatus.error));
      return;
    }
    try {
      await _conversationRepository.sendMessage(
          text: state.message.trim(), conversationID: state.conversationID!);
      emit(state.copyWith(message: ''));
    } catch (e) {
      emit(state.copyWith(status: ConversationStatus.error, message: ''));
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
      final List<Message> messages = [];
      if (messagesSnapshot.isNotEmpty) {
        _conversationRepository.markMessagesAsRead(
            messagesSnapshot, conversationID);
        messages.addAll(
            messagesSnapshot.map((e) => Message.fromJSON(e.data())).toList());
      }
      emit(state.copyWith(
          conversationID: conversationID,
          messagesList: messages,
          status: ConversationStatus.messagesLoaded));
    },
            onError: (err) => emit(state.copyWith(
                status: ConversationStatus.error, errorText: err)));
  }

  Future<void> addConversation({String? companionID}) async {
    try {
      if (companionID == null) throw Exception();
      final conversationID = await _conversationRepository.addConversation(
          companionUID: companionID);
      emit(state.copyWith(
          conversationID: conversationID, status: ConversationStatus.initial));
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
