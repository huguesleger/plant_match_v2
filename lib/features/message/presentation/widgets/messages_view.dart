import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page_route.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_leading.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_subtitle.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_trailing.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/empty_message.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({super.key, required this.chats});

  final List<ChatPlant> chats;

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const EmptyMessage();
    }

    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final chat = chats[index];
        final currentUid = FirebaseAuth.instance.currentUser!.uid;
        final unreadMessagesCount = chat.unreadCount[currentUid] ?? 0;
        final totalUnread = unreadMessagesCount + (chat.hasUnreadExchange ? 1 : 0);

        return ListTile(
          leading: MessageLeading(plantImage: chat.plantImage),
          title: Text(
            chat.plantName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: MessageSubtitle(
            lastMessage: chat.lastMessage,
            isAccepted: chat.acceptedExchangeId != null && !chat.isExchangeCompleted,
          ),
          trailing: MessageTrailing(
            lastMessageAt: chat.lastMessageAt,
            totalUnread: totalUnread,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatPlantPageRoute(
                chatId: chat.chatId,
                plantId: chat.plantId,
                plantOwnerName: chat.plantOwnerName,
                plantOwnerAvatar: chat.plantOwnerAvatar ?? '',
              ),
            ),
          ),
        );
      },
    );
  }
}
