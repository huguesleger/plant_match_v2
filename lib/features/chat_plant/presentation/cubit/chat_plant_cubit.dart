import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';

class ChatPlantCubit extends Cubit<ChatPlantState> {
  final ChatPlantRepository repository;

  StreamSubscription<List<types.Message>>? _messagesSub;
  String? _otherUserId;

  ChatPlantCubit({
    required this.repository,
  }) : super(ChatPlantInitial());

  // ─── subscribe ─────────────────────────────────────────────────────────────

  void subscribe({
    required String chatId,
    required String currentUserId,
  }) {
    emit(ChatPlantLoading());

    repository
        .getParticipants(chatId)
        .match<ChatPlantState>(
          (failure) => ChatPlantError(failure.message),
          (participants) {
            final otherId = participants.firstWhere(
              (id) => id != currentUserId,
              orElse: () => '',
            );

            if (otherId.isEmpty) {
              return ChatPlantError('Impossible de déterminer le destinataire');
            }

            _otherUserId = otherId;
            _messagesSub?.cancel();
            _messagesSub = repository.messagesStream(chatId).listen(
              (messages) {
                if (!isClosed) {
                  emit(ChatPlantLoaded(messages: messages));
                }
              },
              onError: (e) {
                if (!isClosed) {
                  emit(ChatPlantError(e.toString()));
                }
              },
            );

            return state; // On reste en loading ou on garde l'état actuel en attendant les messages
          },
        )
        .map((s) => emit(s))
        .run();
  }

  // ─── send ──────────────────────────────────────────────────────────────────

  void send({
    required String chatId,
    required String senderId,
    required String text,
  }) {
    if (_otherUserId == null || _otherUserId!.isEmpty) return;

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

  // ─── softDeleteChat ────────────────────────────────────────────────────────

  void softDeleteChat(String chatId, String userId) {
    repository
        .softDeleteChat(chatId: chatId, userId: userId)
        .match(
          (failure) =>
              ChatPlantError('Impossible de supprimer la conversation'),
          (_) => state,
        )
        .map((s) => emit(s))
        .run();
  }

  // ─── sendPlantExchange ─────────────────────────────────────────────────────

  void sendPlantExchange({
    required String chatId,
    required String senderId,
    required String plantId,
    required String plantName,
    required String plantImage,
  }) {
    if (_otherUserId == null || _otherUserId!.isEmpty) return;

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

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}
