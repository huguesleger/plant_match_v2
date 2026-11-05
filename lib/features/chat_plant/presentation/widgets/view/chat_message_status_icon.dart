import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class ChatMessageStatusIcon extends StatelessWidget {
  const ChatMessageStatusIcon({super.key, required this.status});

  final Option<types.Status> status;

  @override
  Widget build(BuildContext context) => status.match(
        () => const SizedBox.shrink(),
        (status) => switch (status) {
          types.Status.delivered =>
            const Icon(LucideIcons.check_check, size: 12, color: Colors.grey),
          types.Status.seen => const Icon(LucideIcons.check_check,
              size: 12, color: AppColors.blueGreen),
          types.Status.sent =>
            const Icon(LucideIcons.check, size: 12, color: Colors.grey),
          types.Status.sending =>
            const Icon(LucideIcons.clock, size: 10, color: Colors.grey),
          types.Status.error =>
            const Icon(LucideIcons.circle_alert, size: 12, color: Colors.red),
        },
      );
}
