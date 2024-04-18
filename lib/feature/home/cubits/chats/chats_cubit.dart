import 'package:chats/model/firebase_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsState.initial());

  void loadChats(List<Conversation> conversations) {
    emit(state.copyWith(
        conversations: conversations, status: ChatsStatus.conversationsLoaded));
  }
}
