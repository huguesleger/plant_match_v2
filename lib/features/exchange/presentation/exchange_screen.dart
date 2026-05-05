import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_confirmation.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_picker.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({
    required this.chatId,
    required this.targetPlantId,
    required this.targetOwnerId,
    required this.userId,
    super.key,
  });

  final String chatId;
  final String targetPlantId;
  final String targetOwnerId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeCubit, ExchangeState>(
      builder: (context, state) {
        final (title, body) = switch (state) {
          ExchangeInitial() || ExchangeLoading() => (
              "Chargement...",
              const Center(child: CircularProgressIndicator()),
            ),
          ExchangePickingPlant(:final userPlants) => (
              "Choisir une plante à échanger",
              ExchangePlantPicker(plants: userPlants),
            ),
          ExchangeConfirming(:final targetPlant, :final offeredPlant) => (
              "Confirmer l'échange",
              ExchangeConfirmation(
                targetPlant: targetPlant,
                offeredPlant: offeredPlant,
              ),
            ),
          ExchangeSuccess() => (
              "Succès",
              const Center(child: Text("Échange proposé avec succès !")),
            ),
          ExchangeError(:final message) => (
              "Erreur",
              ErrorPage(
                errorMessage: message,
                onRetry: () => context.read<ExchangeCubit>().initExchange(
                      userId: userId,
                      targetPlantId: targetPlantId,
                      targetOwnerId: targetOwnerId,
                      chatId: chatId,
                    ),
              ),
            ),
          ExchangePending() ||
          ExchangeAccepted() ||
          ExchangeWaitingValidation() ||
          ExchangeRejected() ||
          ExchangeCompleted() =>
            ("", const SizedBox.shrink()),
        };

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: body,
        );
      },
    );
  }
}
