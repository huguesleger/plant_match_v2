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

  Future<void> subscribe({
    required String chatId,
    required String currentUserId,
  }) async {
    emit(ChatPlantLoading());

    try {
      final participants = await repository.getParticipants(chatId);

      _otherUserId = participants.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );

      if (_otherUserId!.isEmpty) {
        throw Exception('Impossible de déterminer le destinataire');
      }

      await _messagesSub?.cancel();

      _messagesSub = repository.messagesStream(chatId).listen(
        (messages) {
          emit(
            ChatPlantLoaded(
              messages: messages,
            ),
          );
        },
        onError: (e) {
          emit(ChatPlantError(e.toString()));
        },
      );
    } catch (e) {
      emit(ChatPlantError(e.toString()));
    }
  }

  Future<void> send({
    required String chatId,
    required String senderId,
    required String text,
  }) async {
    if (_otherUserId == null || _otherUserId!.isEmpty) return;

    try {
      await repository.sendMessage(
        chatId: chatId,
        senderId: senderId,
        receiverId: _otherUserId!,
        text: text,
      );
    } catch (e) {
      emit(ChatPlantError(e.toString()));
    }
  }

  Future<void> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  }) async {
    try {
      await repository.markMessagesAsRead(
        chatId: chatId,
        currentUserId: currentUserId,
      );
    } catch (_) {
      // volontairement silencieux
    }
  }

  Future<void> softDeleteChat(String chatId, String userId) async {
    try {
      await repository.softDeleteChat(chatId: chatId, userId: userId);
    } catch (_) {
      emit(ChatPlantError('Impossible de supprimer la conversation'));
    }
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}
