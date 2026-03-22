import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/data/firebase_chat_plant.dart';
import 'package:plant_match_v2/features/exchange/data/firebase_exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_screen.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_confirmation.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_picker.dart';

class ExchangePageRoute extends StatelessWidget {
  const ExchangePageRoute({
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
      child: BlocListener<ExchangeCubit, ExchangeState>(
        listener: (context, state) {
          if (state is ExchangeSuccess) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                Navigator.pop(context);
              }
            });
          }
        },
        child: BlocBuilder<ExchangeCubit, ExchangeState>(
          builder: (context, state) {
            return switch (state) {
              ExchangeInitial() || ExchangeLoading() => const ExchangeScreen(
                  title: "Chargement...",
                  body: Center(child: CircularProgressIndicator()),
                ),
              ExchangePickingPlant(:final userPlants) => ExchangeScreen(
                  title: "Choisir une plante à échanger",
                  body: ExchangePlantPicker(plants: userPlants),
                ),
              ExchangeConfirming(:final targetPlant, :final offeredPlant) =>
                ExchangeScreen(
                  title: "Confirmer l'échange",
                  body: ExchangeConfirmation(
                    targetPlant: targetPlant,
                    offeredPlant: offeredPlant,
                  ),
                ),
              ExchangeSuccess() => const ExchangeScreen(
                  title: "Succès",
                  body: Center(child: Text("Échange proposé avec succès !")),
                ),
              ExchangeError(:final message) => ExchangeScreen(
                  title: "Erreur",
                  body: ErrorPage(
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
                ),
              _ => const ExchangeScreen(
                  title: "",
                  body: SizedBox.shrink(),
                ),
            };
          },
        ),
      ),
    );
  }
}
