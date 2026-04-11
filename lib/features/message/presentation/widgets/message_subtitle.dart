import 'package:flutter/material.dart';

class MessageSubtitle extends StatelessWidget {
  const MessageSubtitle({
    super.key,
    required this.lastMessage,
    required this.isAccepted,
  });

  final String? lastMessage;
  final bool isAccepted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          lastMessage ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (isAccepted)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 14, color: Colors.green.shade700),
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
    );
  }
}
