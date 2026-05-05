import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/date_formatter.dart';

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
          Option.fromNullable(lastMessageAt).match(
            () => '',
            (date) => DateFormatter.format(context, date),
          ),
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
