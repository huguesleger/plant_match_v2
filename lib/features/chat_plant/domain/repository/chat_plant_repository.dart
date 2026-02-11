import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';

abstract class ChatPlantRepository {
  Future<String> getOrCreatePlantChat({
    required String currentUserId,
    required String plantOwnerId,
    required String plantId,
    required String plantName,
    required String plantDescription,
    required String plantImage,
    required String plantExchangeType,
  });

  Stream<List<types.Message>> messagesStream(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  });

  Stream<List<ChatPlant>> chatsForUser(String uid);

  Future<void> resetUnread(String chatId, String uid);

  Stream<int> unreadCount(String uid);

  Future<void> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  });

  Future<List<String>> getParticipants(String chatId);

  Future<void> softDeleteChat({
    required String chatId,
    required String userId,
  });

  Future<void> sendPlantExchangeMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String plantId,
    required String plantName,
    required String plantImage,
  });
}
