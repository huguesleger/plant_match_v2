import 'package:flutter/material.dart';
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
      ExchangePending() => const ChatPlantInfoBarTemplate(
          text: "Une demande d'échange est en attente de réponse",
          color: Colors.orange,
          icon: Icons.swap_horiz_rounded,
        ),
      ExchangeAccepted() => const ChatPlantInfoBarTemplate(
          text: "Échange accepté 🎉",
          color: Colors.green,
          icon: Icons.check_circle_outline_rounded,
        ),
      ExchangeRejected() => const ChatPlantInfoBarTemplate(
          text: "Échange refusé",
          color: Colors.red,
          icon: Icons.cancel_outlined,
        ),
      ExchangeCompleted() => const ChatPlantInfoBarTemplate(
          text: "Échange terminé ✅",
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
