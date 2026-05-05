import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_action_button.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_action_button_templates.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_page_route.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/validation_code_display.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/validation_code_input.dart';

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
        ValidationCodeDisplay(
          onGenerate: () => context.read<ExchangeCubit>().generateCode(exchange.id),
        ),
      ExchangeWaitingValidation(:final exchange) when isPlantOwner =>
        ValidationCodeDisplay(
          onGenerate: () {}, // Déjà généré
          code: exchange.validationCode,
        ),
      ExchangeWaitingValidation(:final exchange) when !isPlantOwner =>
        ValidationCodeInput(
          onValidate: (code) => context.read<ExchangeCubit>().validateCode(
                exchange.id,
                code,
                currentUserId,
              ),
        ),
      ExchangeAccepted() when !isPlantOwner => const ChatPlantStatusBanner(
          message: "L'échange est accepté ! En attente de la rencontre.",
          icon: LucideIcons.calendar_check,
        ),
      ExchangeInitial() ||
      ExchangeLoading() ||
      ExchangePickingPlant() ||
      ExchangeConfirming() ||
      ExchangeSuccess() ||
      ExchangeError() ||
      ExchangePending() ||
      ExchangeAccepted() ||
      ExchangeWaitingValidation() ||
      ExchangeRejected() ||
      ExchangeCompleted() =>
        (plantOfferType == OfferType.exchange &&
                !isPlantOwner &&
                state is! ExchangePending &&
                state is! ExchangeAccepted &&
                state is! ExchangeCompleted)
            ? ChatPlantActionButton(
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
                backgroundColor: AppColors.greenDark,
                icon: LucideIcons.heart_handshake,
                label: 'Proposer un échange',
              )
            : const SizedBox.shrink(),
    };
  }
}
