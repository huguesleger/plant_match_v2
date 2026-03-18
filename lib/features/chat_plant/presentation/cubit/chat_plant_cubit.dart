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

  void subscribe({
    required String chatId,
    required String currentUserId,
  }) {
    emit(ChatPlantLoading());

    repository.getParticipants(chatId).run().then((result) {
      result.match(
        (failure) => emit(ChatPlantError(failure.message)),
        (participants) {
          _otherUserId = participants.firstWhere(
            (id) => id != currentUserId,
            orElse: () => '',
          );

          if (_otherUserId!.isEmpty) {
            emit(ChatPlantError('Impossible de déterminer le destinataire'));
            return;
          }

          _messagesSub?.cancel();

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
        },
      );
    });
  }

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
        .run()
        .then((result) => result.match(
              (failure) => emit(ChatPlantError(failure.message)),
              (_) => null,
            ));
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
        .run()
        .then((result) => result.match(
              (failure) => emit(ChatPlantError('Impossible de supprimer la conversation')),
              (_) => null,
            ));
  }

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
        .run()
        .then((result) => result.match(
              (failure) => emit(ChatPlantError(failure.message)),
              (_) => null,
            ));
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}
