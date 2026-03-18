import 'package:fpdart/fpdart.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';

abstract class ChatPlantRepository {
  TaskEither<Failure, String> getOrCreatePlantChat({
    required String currentUserId,
    required String plantOwnerId,
    required String plantId,
    required String plantName,
    required String plantDescription,
    required String plantImage,
    required String plantExchangeType,
  });

  Stream<List<types.Message>> messagesStream(String chatId);

  TaskEither<Failure, Unit> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  });

  Stream<List<ChatPlant>> chatsForUser(String uid);

  TaskEither<Failure, Unit> resetUnread(String chatId, String uid);

  Stream<int> unreadCount(String uid);

  TaskEither<Failure, Unit> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  });

  TaskEither<Failure, List<String>> getParticipants(String chatId);

  TaskEither<Failure, Unit> softDeleteChat({
    required String chatId,
    required String userId,
  });

  TaskEither<Failure, Unit> sendPlantExchangeMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String plantId,
    required String plantName,
    required String plantImage,
  });
}
