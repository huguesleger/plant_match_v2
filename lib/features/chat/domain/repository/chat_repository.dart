import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:plant_match_v2/features/chat/domain/entities/chat_user.dart';

abstract class ChatRepository {
  Future<String> getOrCreateChat(String uid1, String uid2);

  Stream<List<types.Message>> messagesStream(String chatId);

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    required String receiverId,
  });

  Stream<List<ChatUser>> chatsForUser(String uid);

  Future<void> resetUnread(String chatId, String uid);

  Stream<int> unreadCount(String uid);

  Future<void> markMessagesAsRead({
    required String chatId,
    required String currentUserId,
  });
}
