import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/chat/domain/entities/chat_user.dart';
import 'package:plant_match_v2/features/chat/presentation/chat_page.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_format_date.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key, required this.chats});

  final List<ChatUser> chats;

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
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.greyLight,
              backgroundImage: (chat.otherUserAvatar != null &&
                      chat.otherUserAvatar!.isNotEmpty &&
                      chat.otherUserAvatar != 'null')
                  ? NetworkImage(chat.otherUserAvatar!)
                  : null,
              child: (chat.otherUserAvatar == null ||
                      chat.otherUserAvatar!.isEmpty ||
                      chat.otherUserAvatar == 'null')
                  ? Text(
                      chat.otherUserName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            title: Text(
              chat.otherUserName,
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
                  builder: (_) => ChatPage(
                    chatId: chat.chatId,
                    otherUserId: chat.otherUserId,
                    otherUserName: chat.otherUserName,
                    otherUserAvatar: chat.otherUserAvatar ?? '',
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
