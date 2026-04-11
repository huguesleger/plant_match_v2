import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_action_button_templates.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_page_route.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ChatPlantExchangeActionBar extends StatelessWidget {
  const ChatPlantExchangeActionBar({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantOwnerId,
    required this.plantOfferType,
    required this.currentUserId,
    required this.state,
  });

  final String chatId;
  final String plantId;
  final String plantOwnerId;
  final OfferType plantOfferType;
  final String currentUserId;
  final ExchangeState state;

  @override
  Widget build(BuildContext context) {
    final bool isPlantOwner = currentUserId == plantOwnerId;

    return switch (state) {
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
                state is! ExchangePending &&
                state is! ExchangeAccepted &&
                state is! ExchangeCompleted)
            ? _ProposeExchangeButton(
                chatId: chatId,
                plantId: plantId,
                plantOwnerId: plantOwnerId,
              )
            : const SizedBox.shrink(),
    };
  }
}

class _ProposeExchangeButton extends StatelessWidget {
  const _ProposeExchangeButton({
    required this.chatId,
    required this.plantId,
    required this.plantOwnerId,
  });

  final String chatId;
  final String plantId;
  final String plantOwnerId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExchangePageRoute(
              chatId: chatId,
              targetPlantId: plantId,
              targetOwnerId: plantOwnerId,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenDark,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(LucideIcons.heart_handshake, color: Colors.white),
        label: const Text(
          'Proposer un échange',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppTypo.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
