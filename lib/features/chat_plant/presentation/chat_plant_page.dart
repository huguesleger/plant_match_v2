import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/chat_plant/domain/repository/chat_plant_repository.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/chat_plant_screen.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/donation/data/firebase_donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';

class ChatPlantPage extends StatelessWidget {
  ChatPlantPage({
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

  final ChatPlantRepository chatRepository = FirebaseChatPlant();
  final catalogRepo = FirebaseCatalogRepository();

  @override
  Widget build(BuildContext context) {
    final currentUser = fb_auth.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExchangeCubit(
            repository: FirebaseExchange(),
            chatRepository: chatRepository,
          )..listen(chatId),
        ),
        BlocProvider(
          create: (_) =>
              DonationCubit(repository: FirebaseDonation())..listen(chatId),
        ),
      ],
      child: BlocProvider(
        create: (_) => ChatPlantCubit(repository: chatRepository)
          ..subscribe(
            chatId: chatId,
            currentUserId: currentUser.uid,
          )
          ..markMessagesAsRead(
            chatId: chatId,
            currentUserId: currentUser.uid,
          ),
        child: FutureBuilder<Catalog?>(
          future: catalogRepo
              .getCatalogById(plantId)
              .map((opt) => opt.toNullable())
              .getOrElse((_) => null)
              .run(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final plant = snapshot.data!;

            return BlocBuilder<ChatPlantCubit, ChatPlantState>(
              builder: (context, state) {
                return switch (state) {
                  ChatPlantInitial() || ChatPlantLoading() => const Scaffold(
                      backgroundColor: AppColors.white,
                      body: Center(child: CircularProgressIndicator()),
                    ),
                  ChatPlantError() => ErrorPage(
                      errorMessage: state.message,
                      onRetry: () {
                        context.read<ChatPlantCubit>().subscribe(
                          chatId: chatId,
                          currentUserId: currentUser.uid,
                        );
                      },
                    ),
                  ChatPlantLoaded() => ChatPlantScreen(
                      chatId: chatId,
                      plantId: plant.catalogId!,
                      plantName: plant.name,
                      plantDescription: plant.description,
                      plantImage:
                          plant.images.isNotEmpty ? plant.images.first : '',
                      plantOfferType: plant.offerType,
                      plantOwnerId: plant.userId,
                      plantOwnerName: plantOwnerName,
                      plantOwnerAvatar: plantOwnerAvatar,
                      messages: state.messages,
                    ),
                };
              },
            );
          },
        ),
      ),
    );
  }
}
