import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';

class ChatPlantCubit extends Cubit<ChatPlantState> {
  final ChatPlantRepository repository;

  StreamSubscription<List<types.Message>>? _messagesSub;
  StreamSubscription<bool>? _blockedSub;
  String? _otherUserId;
  bool _isBlocked = false;
  List<types.Message> _currentMessages = [];

  ChatPlantCubit({
    required this.repository,
  }) : super(ChatPlantInitial());

  void subscribe({
    required String chatId,
    required String currentUserId,
    required String otherUserId,
  }) {
    emit(ChatPlantLoading());

    _otherUserId = otherUserId;

    _blockedSub?.cancel();
    _blockedSub = repository
        .isBlockedStream(
          currentUserId: currentUserId,
          otherUserId: otherUserId,
        )
        .listen((isBlocked) {
      if (isClosed) return;
      _isBlocked = isBlocked;
      if (state is ChatPlantLoaded) {
        emit(ChatPlantLoaded(
          messages: _currentMessages,
          isBlocked: _isBlocked,
        ));
      }
    });

    _messagesSub?.cancel();
    _messagesSub = repository.messagesStream(chatId).listen(
      (messages) {
        if (!isClosed) {
          _currentMessages = messages;
          emit(ChatPlantLoaded(
            messages: messages,
            isBlocked: _isBlocked,
          ));
        }
      },
      onError: (e) {
        if (!isClosed) {
          emit(ChatPlantError(e.toString()));
        }
      },
    );
  }

  void send({
    required String chatId,
    required String senderId,
    required String text,
  }) {
    if (_otherUserId == null || _otherUserId!.isEmpty) return;
    if (_isBlocked) return;

    repository
        .sendMessage(
          chatId: chatId,
          senderId: senderId,
          receiverId: _otherUserId!,
          text: text,
        )
        .match(
          (failure) => ChatPlantError(failure.message),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  void markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) {
    repository
        .markMessagesAsRead(
          chatId: chatId,
          currentUserId: currentUserId,
        )
        .run();
  }

  void softDeleteChat(String chatId, String userId) {
    repository
        .softDeleteChat(chatId: chatId, userId: userId)
        .match(
          (failure) => ChatPlantError('Impossible de supprimer la conversation'),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  void sendPlantExchange({
    required String chatId,
    required String senderId,
    required String plantId,
    required String plantName,
    required String plantImage,
  }) {
    if (_otherUserId == null || _otherUserId!.isEmpty) return;
    if (_isBlocked) return;

    repository
        .sendPlantExchangeMessage(
          chatId: chatId,
          senderId: senderId,
          receiverId: _otherUserId!,
          plantId: plantId,
          plantName: plantName,
          plantImage: plantImage,
        )
        .match(
          (failure) => ChatPlantError(failure.message),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  void reportChat({
    required String chatId,
    required String reporterUserId,
    required String reportedUserId,
  }) {
    repository
        .reportChat(
          chatId: chatId,
          reporterUserId: reporterUserId,
          reportedUserId: reportedUserId,
        )
        .run();
  }

  void blockUser({
    required String blockerUserId,
    required String blockedUserId,
  }) {
    repository
        .blockUser(
          blockerUserId: blockerUserId,
          blockedUserId: blockedUserId,
        )
        .run();
  }

  void unblockUser({
    required String blockerUserId,
    required String blockedUserId,
  }) {
    repository
        .unblockUser(
          blockerUserId: blockerUserId,
          blockedUserId: blockedUserId,
        )
        .run();
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    _blockedSub?.cancel();
    return super.close();
  }
}
