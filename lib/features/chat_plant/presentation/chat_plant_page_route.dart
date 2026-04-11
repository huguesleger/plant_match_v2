import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_screen.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/donation/data/firebase_donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';

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
    final currentUser = fb_auth.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
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
              currentUserId: currentUser.uid,
            )
            ..markMessagesAsRead(
              chatId: chatId,
              currentUserId: currentUser.uid,
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
