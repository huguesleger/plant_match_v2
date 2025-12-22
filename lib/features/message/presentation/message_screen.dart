import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_format_date.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key, required this.chats});

  final List<ChatPlant> chats;

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Aucune conversation')),
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
            subtitle: Text(
              chat.lastMessage ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              //mainAxisSize: MainAxisSize.min,
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
                if ((chat.unreadCount[currentUid] ?? 0) > 0)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.greenDark,
                    child: Text(
                      chat.unreadCount[currentUid]! > 9
                          ? '9+'
                          : chat.unreadCount[currentUid]!.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPlantPage(
                    chatId: chat.chatId,
                    plantId: chat.plantId,
                    plantName: chat.plantName,
                    plantDescription: chat.plantDescription,
                    plantImage: chat.plantImage,
                    plantExchangeType: chat.plantExchangeType,
                    plantOwnerId: chat.plantOwnerId,
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
