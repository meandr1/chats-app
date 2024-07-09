import 'package:chats/app_constants.dart';
import 'package:chats/feature/chats/repository/chats_repository.dart';

import 'package:chats/models/conversation_layout.dart';
import 'package:chats/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatsRepository _chatsRepository;
  ChatsCubit(this._chatsRepository) : super(ChatsState.initial());

  void loadChats(List<ConversationsListEntry> conversationsList) async {
    if (state.status == ChatsStatus.conversationsLoaded) return;
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    final db = FirebaseFirestore.instance;
    final cacheConversations =
        _chatsRepository.getConversationsFromCache(currentUID);
    if (cacheConversations != null) {
      emit(state.copyWith(
          conversations: cacheConversations,
          status: ChatsStatus.conversationsLoaded));
    }
    final conversationsRef =
        db.collection(AppConstants.usersCollection).doc(currentUID);
    conversationsRef.snapshots().listen(
      (event) async {
        final jsonOfConversations =
            event.data()?['conversations'] as Map<String, dynamic>;
        final List<ConversationsListEntry> conversationsList = [];
        jsonOfConversations.entries.toList().forEach((entry) =>
            conversationsList.add(ConversationsListEntry.fromJSON(entry)));
        final usersList =
            await _chatsRepository.getUsersList(conversationsList);
        final lastMessagesListener =
            List<ConversationsListEntry>.from(conversationsList)
                .asMap()
                .entries;
        lastMessagesListener
            .map((e) => db
                    .collection(e.value.conversationID)
                    .orderBy(AppConstants.messageTimestampField,
                        descending: true)
                    .limit(1)
                    .snapshots()
                    .listen((event) async {
                  if (event.docs.isNotEmpty) {
                    final message = Message.fromJSON(event.docs.first.data());
                    final unreadMessagesCount =
                        await _chatsRepository.getUnreadMessageCount(
                            conversationID: e.value.conversationID,
                            currentUID: currentUID!);
                    await _chatsRepository.markMessagesAsDelivered(e.value);
                    final currentConversationLayout =
                        _chatsRepository.getConversationLayout(
                            user: usersList[e.key],
                            conversationEntry: conversationsList[e.key],
                            message: message,
                            unreadMessagesCount: unreadMessagesCount);
                    final updatedConversationsList = await updateStateConversations(
                        currentConversationLayout, currentUID);
                    emit(state.copyWith(
                        conversations: updatedConversationsList,
                        status: ChatsStatus.conversationsLoaded));
                  }
                }, onError: onListenError))
            .toList();
      },
      onError: onListenError,
    );
  }

  Future<List<ConversationLayout>> updateStateConversations(
      ConversationLayout newConversationLayout, String currentUID) async {
    final stateConversations = [
      ...?state.conversations?.where(
          (el) => el.conversationID != newConversationLayout.conversationID),
      newConversationLayout
    ];
    await _chatsRepository.updateConversationsCache(stateConversations, currentUID);
    return stateConversations;
  }

  void onListenError(error) {
    emit(state.copyWith(status: ChatsStatus.error, errorText: error));
  }

  Future<void> deleteChat(
      {required String companionID, required String conversationID}) async {
    emit(state.copyWith(
        conversations: state.conversations!
            .where((el) => el.companionID != companionID)
            .toList(),
        status: ChatsStatus.conversationsLoaded));
    try {
      await _chatsRepository.deleteConversation(
          companionUID: companionID, conversationID: conversationID);
    } catch (e) {
      emit(state.copyWith(status: ChatsStatus.error));
    }
  }

  void clearStateConversations() {
    emit(state.copyWith(conversations: [], status: ChatsStatus.initial));
  }
}
