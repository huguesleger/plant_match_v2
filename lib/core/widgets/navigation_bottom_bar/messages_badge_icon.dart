import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/unread_exhange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/unread_exhange_state.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/unread_messages_cubit.dart';
import 'package:plant_match_v2/features/message/presentation/state/unread_messages_state.dart';

class MessagesBadgeIcon extends StatelessWidget {
  const MessagesBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnreadMessagesCubit, UnreadMessagesState>(
      builder: (context, messageState) {
        return BlocBuilder<UnreadExchangesCubit, UnreadExchangesState>(
          builder: (context, exchangeState) {
            int unreadMessages = 0;
            int unreadExchanges = 0;

            if (messageState is UnreadMessagesLoaded) {
              unreadMessages = messageState.count;
            }

            if (exchangeState is UnreadExchangesLoaded) {
              unreadExchanges = exchangeState.count;
            }

            final totalUnread = unreadMessages + unreadExchanges;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(LucideIcons.message_square_text),
                if (totalUnread > 0)
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
                        totalUnread > 9 ? '9+' : totalUnread.toString(),
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
      },
    );
  }
}
