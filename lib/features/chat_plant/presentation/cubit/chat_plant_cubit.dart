import 'dart:async';

import 'package:plant_match_v2/core/util/safe_cubit.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';

class ChatPlantCubit extends SafeCubit<ChatPlantState> {
  final ChatPlantRepository repository;

  Option<StreamSubscription<List<types.Message>>> _messagesSub = const None();
  Option<StreamSubscription<BlockStatus>> _blockedSub = const None();
  Option<String> _otherUserId = const None();
  BlockStatus _blockStatus = BlockStatus.none;
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

    _otherUserId = Some(otherUserId);

    _blockedSub.map((sub) => sub.cancel());
    _blockedSub = Some(repository
        .blockStatusStream(
      currentUserId: currentUserId,
      otherUserId: otherUserId,
    )
        .listen(
      (blockStatus) {
        if (isClosed) return;
        _blockStatus = blockStatus;
        if (state is ChatPlantLoaded) {
          emit(ChatPlantLoaded(
            messages: _currentMessages,
            blockStatus: _blockStatus,
          ));
        }
      },
      onError: (_) {},
    ));

    _messagesSub.map((sub) => sub.cancel());
    _messagesSub = Some(repository.messagesStream(chatId).listen(
      (messages) {
        if (!isClosed) {
          _currentMessages = messages;
          emit(ChatPlantLoaded(
            messages: messages,
            blockStatus: _blockStatus,
          ));
        }
      },
      onError: (Object error) {
        if (!isClosed) {
          emit(ChatPlantError(mapError(error)));
        }
      },
    ));
  }

  Future<Option<Failure>> send({
    required String chatId,
    required String senderId,
    required String text,
  }) =>
      _sendableReceiverId.match(
        () async => const None(),
        (receiverId) => repository
            .payFirstContact(
              chatId: chatId,
              senderId: senderId,
              receiverId: receiverId,
            )
            .flatMap(
              (_) => repository.sendMessage(
                chatId: chatId,
                senderId: senderId,
                receiverId: receiverId,
                text: text,
              ),
            )
            .match<Option<Failure>>(
              (failure) => Some(failure),
              (_) => const None(),
            )
            .run(),
      );

  Option<String> get _sendableReceiverId => _otherUserId
      .filter((id) => id.isNotEmpty)
      .filter((_) => _blockStatus == BlockStatus.none);

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
          (failure) => ChatPlantError(failure),
          (_) => state,
        )
        .map(emit)
        .run();
  }

  void sendPlantExchange({
    required String chatId,
    required String senderId,
    required String plantId,
    required String plantName,
    required String plantImage,
  }) {
    _sendableReceiverId.map(
      (receiverId) => repository
          .sendPlantExchangeMessage(
            chatId: chatId,
            senderId: senderId,
            receiverId: receiverId,
            plantId: plantId,
            plantName: plantName,
            plantImage: plantImage,
          )
          .match(
            (failure) => ChatPlantError(failure),
            (_) => state,
          )
          .map(emit)
          .run(),
    );
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
    _messagesSub.map((sub) => sub.cancel());
    _blockedSub.map((sub) => sub.cancel());
    return super.close();
  }
}
