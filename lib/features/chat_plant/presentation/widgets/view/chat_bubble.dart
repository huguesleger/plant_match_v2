import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/util/date_formatter.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_theme.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/view/chat_message_status_icon.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.child,
  });

  final types.Message message;
  final String currentUserId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = message.author.id == currentUserId;
    final time = DateFormatter.formatTime(
      context,
      DateTime.fromMillisecondsSinceEpoch(
        Option.fromNullable(message.createdAt).getOrElse(() => 0),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        message is types.CustomMessage
            ? child
            : Container(
                decoration: BoxDecoration(
                  color: isCurrentUser
                      ? ChatThemes.light.primaryColor
                      : ChatThemes.light.secondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isCurrentUser ? 12 : 0),
                    bottomRight: Radius.circular(isCurrentUser ? 0 : 12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    child,
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.greyDark.withValues(alpha: 0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isCurrentUser) ...[
                            const SizedBox(width: 4),
                            ChatMessageStatusIcon(
                              status: Option.fromNullable(message.status),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
