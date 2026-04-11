import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_action_buttons.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ChatPlantActionBars extends StatelessWidget {
  const ChatPlantActionBars({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.plantOwnerId,
    required this.plantOfferType,
    required this.currentUserId,
    required this.exchangeState,
    required this.donationState,
  });

  final String chatId;
  final String plantId;
  final String plantName;
  final String plantImage;
  final String plantOwnerId;
  final OfferType plantOfferType;
  final String currentUserId;
  final ExchangeState exchangeState;
  final DonationState donationState;

  @override
  Widget build(BuildContext context) {
    final bool isPlantOwner = currentUserId == plantOwnerId;

    return Column(
      children: [
        switch (exchangeState) {
          ExchangePending(:final exchange) when isPlantOwner =>
            ChatPlantAcceptOrRefuseBar(
              label: "l'échange",
              onAccept: () => context.read<ExchangeCubit>().accept(exchange.id),
              onRefuse: () => context.read<ExchangeCubit>().reject(exchange.id),
            ),
          ExchangeAccepted(:final exchange) when isPlantOwner =>
            ChatPlantCompleteActionBar(
              label: "l'échange",
              dialogTitle: "Clôturer l'échange",
              dialogContent: 'Avez-vous effectué l\'échange physique ?',
              onConfirm: () => context
                  .read<ExchangeCubit>()
                  .complete(exchange.id, currentUserId),
            ),
          ExchangeInitial() ||
          ExchangeLoading() ||
          ExchangePickingPlant() ||
          ExchangeConfirming() ||
          ExchangeSuccess() ||
          ExchangeError() ||
          ExchangePending() ||
          ExchangeAccepted() ||
          ExchangeRejected() ||
          ExchangeCompleted() =>
            (plantOfferType == OfferType.exchange &&
                    !isPlantOwner &&
                    exchangeState is! ExchangePending &&
                    exchangeState is! ExchangeAccepted &&
                    exchangeState is! ExchangeCompleted)
                ? ChatPlantExchangeActionBar(
                    chatId: chatId,
                    targetPlantId: plantId,
                    targetOwnerId: plantOwnerId,
                  )
                : const SizedBox.shrink(),
        },
        switch (donationState) {
          DonationPending(:final donation) when isPlantOwner =>
            ChatPlantAcceptOrRefuseBar(
              label: 'la donation',
              onAccept: () => context.read<DonationCubit>().accept(donation.id),
              onRefuse: () => context.read<DonationCubit>().reject(donation.id),
            ),
          DonationAccepted(:final donation) when isPlantOwner =>
            ChatPlantCompleteActionBar(
              label: 'la donation',
              dialogTitle: 'Clôturer la donation',
              dialogContent: 'Avez-vous remis la plante au bénéficiaire ?',
              onConfirm: () => context
                  .read<DonationCubit>()
                  .complete(donation.id, currentUserId),
            ),
          DonationInitial() ||
          DonationLoading() ||
          DonationPending() ||
          DonationAccepted() ||
          DonationRejected() ||
          DonationCompleted() ||
          DonationError() =>
            (plantOfferType == OfferType.donation &&
                    !isPlantOwner &&
                    donationState is! DonationPending &&
                    donationState is! DonationAccepted &&
                    donationState is! DonationCompleted)
                ? ChatPlantDonationRequestBar(
                    onPressed: () => showDonationConfirmDialog(
                      context: context,
                      chatId: chatId,
                      currentUserId: currentUserId,
                      plantId: plantId,
                      plantName: plantName,
                      plantImage: plantImage,
                      ownerId: plantOwnerId,
                    ),
                  )
                : const SizedBox.shrink(),
        },
      ],
    );
  }
}
