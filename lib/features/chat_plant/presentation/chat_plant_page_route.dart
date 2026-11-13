import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_screen.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_notification_prompt.dart';
import 'package:plant_match_v2/features/donation/data/firebase_donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:plant_match_v2/features/notifications/presentation/cubit/notification_prompt_cubit.dart';

class ChatPlantPageRoute extends StatelessWidget {
  const ChatPlantPageRoute({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantOwnerName,
    required this.plantOwnerAvatar,
    required this.otherUserId,
  });

  final String chatId;
  final String plantId;
  final String plantOwnerName;
  final String plantOwnerAvatar;
  final String otherUserId;

  @override
  Widget build(BuildContext context) {
    return context.read<AuthCubit>().userId.match(
          () => Scaffold(
            body: Center(child: Text(t.common.notConnected)),
          ),
          (userId) => _buildChat(context, userId),
        );
  }

  Widget _buildChat(BuildContext context, String userId) {
    final chatRepository = FirebaseChatPlant();
    final notificationRepository =
        context.read<NotificationCubit>().notificationRepository;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExchangeCubit(
            repository: FirebaseExchange(),
          )..listen(chatId),
        ),
        BlocProvider(
          create: (_) => DonationCubit(
            repository: FirebaseDonation(),
            chatRepository: chatRepository,
          )..listen(chatId),
        ),
        BlocProvider(
          create: (_) => ChatPlantCubit(repository: chatRepository)
            ..subscribe(
              chatId: chatId,
              currentUserId: userId,
              otherUserId: otherUserId,
            )
            ..markMessagesAsRead(
              chatId: chatId,
              currentUserId: userId,
            ),
        ),
        BlocProvider(
          create: (_) => NotificationPromptCubit(
            notificationRepository: notificationRepository,
            userId: userId,
          ),
        ),
      ],
      child: ChatNotificationPrompt(
        child: ChatPlantScreen(
          chatId: chatId,
          otherUserId: otherUserId,
          plantId: plantId,
          plantOwnerName: plantOwnerName,
          plantOwnerAvatar: plantOwnerAvatar,
        ),
      ),
    );
  }
}
