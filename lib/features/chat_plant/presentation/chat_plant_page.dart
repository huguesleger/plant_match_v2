import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_screen.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';

class ChatPlantPage extends StatelessWidget {
  ChatPlantPage({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantName,
    required this.plantDescription,
    required this.plantImage,
    required this.plantExchangeType,
    required this.plantOwnerId,
    required this.plantOwnerName,
    required this.plantOwnerAvatar,
  });

  final String chatId;

  final String plantId;
  final String plantName;
  final String plantDescription;
  final String plantImage;
  final String plantExchangeType;

  final String plantOwnerId;
  final String plantOwnerName;
  final String plantOwnerAvatar;

  final ChatPlantRepository chatRepository = FirebaseChatPlant();

  @override
  Widget build(BuildContext context) {
    final currentUser = fb_auth.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return BlocProvider(
      create: (_) => ChatPlantCubit(repository: chatRepository)
        ..subscribe(
          chatId: chatId,
          currentUserId: currentUser.uid,
        )
        ..markMessagesAsRead(
          chatId: chatId,
          currentUserId: currentUser.uid,
        ),
      child: BlocBuilder<ChatPlantCubit, ChatPlantState>(
        builder: (context, state) {
          return switch (state) {
            ChatPlantInitial() || ChatPlantLoading() => const Scaffold(
                backgroundColor: AppColors.white,
                body: Center(child: CircularProgressIndicator()),
              ),
            ChatPlantError() => ErrorPage(errorMessage: state.message),
            ChatPlantLoaded() => ChatPlantScreen(
                chatId: chatId,
                plantId: plantId,
                plantName: plantName,
                plantDescription: plantDescription,
                plantImage: plantImage,
                plantExchangeType: plantExchangeType,
                plantOwnerId: plantOwnerId,
                plantOwnerName: plantOwnerName,
                plantOwnerAvatar: plantOwnerAvatar,
              ),
          };
        },
      ),
    );
  }
}
