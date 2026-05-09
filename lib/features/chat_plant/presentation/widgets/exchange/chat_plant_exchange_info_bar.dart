import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_info_bar_template.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ChatPlantExchangeInfoBar extends StatelessWidget {
  const ChatPlantExchangeInfoBar({
    super.key,
    required this.state,
  });

  final ExchangeState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ExchangePending() => ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.exchange.pending,
          color: Colors.orange,
          icon: Icons.swap_horiz_rounded,
        ),
      ExchangeAccepted() || ExchangeWaitingValidation() =>
        ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.exchange.accepted,
          color: Colors.green,
          icon: Icons.check_circle_outline_rounded,
        ),
      ExchangeRejected() => ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.exchange.rejected,
          color: Colors.red,
          icon: Icons.cancel_outlined,
        ),
      ExchangeCompleted() => ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.exchange.completed,
          color: Colors.blue,
          icon: Icons.task_alt_rounded,
        ),
      ExchangeInitial() ||
      ExchangeLoading() ||
      ExchangePickingPlant() ||
      ExchangeConfirming() ||
      ExchangeSuccess() ||
      ExchangeError() =>
        const SizedBox.shrink(),
    };
  }
}
