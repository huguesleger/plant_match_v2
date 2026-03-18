import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_screen.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ExchangePage extends StatelessWidget {
  const ExchangePage({
    required this.chatId,
    required this.targetPlantId,
    required this.targetOwnerId,
    super.key,
  });

  final String chatId;
  final String targetPlantId;
  final String targetOwnerId;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté")),
      );
    }

    return BlocProvider(
      create: (context) => ExchangeCubit(
        repository: FirebaseExchange(),
        chatRepository: FirebaseChatPlant(),
      )..initExchange(
          userId: userId,
          targetPlantId: targetPlantId,
          targetOwnerId: targetOwnerId,
          chatId: chatId,
        ),
      child: BlocConsumer<ExchangeCubit, ExchangeState>(
        listener: (context, state) {
          if (state is ExchangeSuccess) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state is ExchangeConfirming
                  ? "Confirmer l'échange"
                  : "Choisir une plante à échanger"),
            ),
            body: switch (state) {
              ExchangeInitial() || ExchangeLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              ExchangePickingPlant(:final userPlants) => ExchangeScreen(
                  userPlants: userPlants,
                ),
              ExchangeConfirming(:final targetPlant, :final offeredPlant) =>
                ExchangeScreen(
                  targetPlant: targetPlant,
                  offeredPlant: offeredPlant,
                ),
              ExchangeSuccess() => const Center(
                  child: Text("Échange proposé avec succès !"),
                ),
              ExchangeError(:final message) => ErrorPage(
                  errorMessage: message,
                  onRetry: () {
                    context.read<ExchangeCubit>().initExchange(
                      userId: userId,
                      targetPlantId: targetPlantId,
                      targetOwnerId: targetOwnerId,
                      chatId: chatId,
                    );
                  },
                ),
              // Gestion des états hérités si nécessaire dans cette vue
              _ => const SizedBox.shrink(),
            },
          );
        },
      ),
    );
  }
}
