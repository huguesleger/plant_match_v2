import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_screen.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/donation/data/firebase_donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class ChatPlantPageRoute extends StatelessWidget {
  const ChatPlantPageRoute({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantOwnerName,
    required this.plantOwnerAvatar,
  });

  final String chatId;
  final String plantId;
  final String plantOwnerName;
  final String plantOwnerAvatar;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return Scaffold(
        body: Center(child: Text(t.message.errors.not_connected)),
      );
    }

    final chatRepository = FirebaseChatPlant();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExchangeCubit(
            repository: FirebaseExchange(),
            chatRepository: chatRepository,
          )..listen(chatId),
        ),
        BlocProvider(
          create: (_) => DonationCubit(repository: FirebaseDonation())..listen(chatId),
        ),
        BlocProvider(
          create: (_) => ChatPlantCubit(repository: chatRepository)
            ..subscribe(
              chatId: chatId,
              currentUserId: userId,
            )
            ..markMessagesAsRead(
              chatId: chatId,
              currentUserId: userId,
            ),
        ),
      ],
      child: ChatPlantScreen(
        chatId: chatId,
        plantId: plantId,
        plantOwnerName: plantOwnerName,
        plantOwnerAvatar: plantOwnerAvatar,
      ),
    );
  }
}
