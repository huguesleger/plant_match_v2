import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page_route.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/empty_message.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_format_date.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key, required this.chats});

  final List<ChatPlant> chats;

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.green,
        body: EmptyMessage(),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          final currentUid = FirebaseAuth.instance.currentUser!.uid;
          final unreadMessagesCount = chat.unreadCount[currentUid] ?? 0;
          final totalUnread =
              unreadMessagesCount + (chat.hasUnreadExchange ? 1 : 0);

          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: chat.plantImage.isNotEmpty
                  ? Image.network(
                      chat.plantImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 50,
                      height: 50,
                      color: AppColors.greyLight,
                      child: const Icon(
                        Icons.local_florist,
                        color: AppColors.greyDark,
                      ),
                    ),
            ),
            title: Text(
              chat.plantName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  chat.lastMessage ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (chat.acceptedExchangeId != null &&
                    !chat.isExchangeCompleted)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            size: 14, color: Colors.green.shade700),
                        const SizedBox(width: 4),
                        Text(
                          'Échange accepté',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  chat.lastMessageAt != null
                      ? messageFormatDate(context, chat.lastMessageAt!)
                      : '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                if (totalUnread > 0)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.greenDark,
                    child: Text(
                      totalUnread > 9 ? '9+' : totalUnread.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPlantPageRoute(
                    chatId: chat.chatId,
                    plantId: chat.plantId,
                    plantOwnerName: chat.plantOwnerName,
                    plantOwnerAvatar: chat.plantOwnerAvatar ?? '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
