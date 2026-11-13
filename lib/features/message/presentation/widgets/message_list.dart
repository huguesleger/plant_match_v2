import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/chat_plant/domain/entities/chat_plant.dart';
import 'package:plant_match_v2/features/message/presentation/message_item.dart';

class MessageList extends StatelessWidget {
  const MessageList({super.key, required this.chats});

  final List<ChatPlant> chats;

  @override
  Widget build(BuildContext context) => ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Divider(height: 1, color: AppColors.greyLight),
        ),
        itemBuilder: (context, index) => MessageItem(chat: chats[index]),
      );
}
