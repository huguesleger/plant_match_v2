import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_page_route.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_leading.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_subtitle.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_trailing.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.chat,
  });

  final ChatPlant chat;

  @override
  Widget build(BuildContext context) {
    final currentUid = context.read<AuthCubit>().userId ?? '';
    final unreadMessagesCount = chat.unreadCount[currentUid] ?? 0;
    final totalUnread = unreadMessagesCount + (chat.hasUnreadExchange ? 1 : 0);

    return ListTile(
      leading: MessageLeading(
        plantImage: chat.plantImage,
        isOnline: chat.isOtherUserOnline,
      ),
      title: Text(
        chat.plantName,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: InterTextStyle.inter(
          AppTypo.text,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: MessageSubtitle(
        lastMessage: chat.lastMessage.toNullable(),
      ),
      trailing: MessageTrailing(
        lastMessageAt: chat.lastMessageAt.toNullable(),
        totalUnread: totalUnread,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatPlantPageRoute(
            chatId: chat.chatId,
            plantId: chat.plantId,
            plantOwnerName: chat.plantOwnerName,
            plantOwnerAvatar: chat.plantOwnerAvatar.getOrElse(() => ''),
            otherUserId: chat.otherUserId,
          ),
        ),
      ),
    );
  }
}
