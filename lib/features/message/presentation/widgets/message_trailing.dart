import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_format_date.dart';

class MessageTrailing extends StatelessWidget {
  const MessageTrailing({
    super.key,
    required this.lastMessageAt,
    required this.totalUnread,
  });

  final DateTime? lastMessageAt;
  final int totalUnread;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(
          lastMessageAt != null
              ? messageFormatDate(context, lastMessageAt!)
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
    );
  }
}
