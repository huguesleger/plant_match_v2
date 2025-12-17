import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat/presentation/state/chat_state.dart';
import 'package:plant_match_v2/features/chat/repository/chat_repository.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository repository;

  StreamSubscription? _sub;

  ChatCubit({required this.repository}) : super(ChatInitial());

  void subscribe(String chatId) {
    emit(ChatLoading());
    _sub = repository.messagesStream(chatId).listen(
      (messages) {
        emit(ChatLoaded(messages: messages));
      },
      onError: (e) {
        emit(ChatError(e.toString()));
      },
    );
  }

  Future<void> send({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    return repository.sendMessage(
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
    );
  }

  Future<void> resetUnread(String chatId, String uid) {
    return repository.resetUnread(chatId, uid);
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) {
    return repository.markMessagesAsRead(
      chatId: chatId,
      currentUserId: currentUserId,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
