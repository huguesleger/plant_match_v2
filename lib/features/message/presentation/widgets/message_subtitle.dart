import 'package:flutter/material.dart';

class MessageSubtitle extends StatelessWidget {
  const MessageSubtitle({
    super.key,
    required this.lastMessage,
  });

  final String? lastMessage;
 

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
      ],
    );
  }
}
