import 'package:fpdart/fpdart.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';

abstract class ChatPlantRepository {
  TaskEither<Failure, String> getOrCreatePlantChat({
    required String currentUserId,
    required String plantOwnerId,
    required String plantId,
    required String plantName,
    required String plantDescription,
    required String plantImage,
    required OfferType plantExchangeType,
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

  TaskEither<Failure, Unit> sendPlantDonationMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String plantId,
    required String plantName,
    required String plantImage,
  });

  TaskEither<Failure, Unit> reportChat({
    required String chatId,
    required String reporterUserId,
    required String reportedUserId,
  });

  TaskEither<Failure, Unit> blockUser({
    required String blockerUserId,
    required String blockedUserId,
  });

  TaskEither<Failure, Unit> unblockUser({
    required String blockerUserId,
    required String blockedUserId,
  });

  Stream<bool> isBlockedStream({
    required String currentUserId,
    required String otherUserId,
  });
}
