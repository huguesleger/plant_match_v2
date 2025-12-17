import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/unread_messages_cubit.dart';
import 'package:plant_match_v2/features/message/presentation/state/unread_messages_state.dart';

class MessagesBadgeIcon extends StatelessWidget {
  const MessagesBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnreadMessagesCubit, UnreadMessagesState>(
      builder: (context, state) {
        int count = 0;
        if (state is UnreadMessagesLoaded) {
          count = state.count;
        }
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(LucideIcons.message_square_text),
            if (count > 0)
              Positioned(
                right: -8,
                top: -10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.greenDark,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    count > 9 ? '9+' : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
