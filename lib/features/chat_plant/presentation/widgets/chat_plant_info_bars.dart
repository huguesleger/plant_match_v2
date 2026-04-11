import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ChatPlantInfoBars extends StatelessWidget {
  const ChatPlantInfoBars({
    super.key,
    required this.exchangeState,
    required this.donationState,
  });

  final ExchangeState exchangeState;
  final DonationState donationState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        switch (exchangeState) {
          ExchangePending() => const _InfoBar(
              text: "Une demande d'échange est en attente de réponse",
              color: Colors.orange,
              icon: Icons.swap_horiz_rounded,
            ),
          ExchangeAccepted() => const _InfoBar(
              text: "Échange accepté 🎉",
              color: Colors.green,
              icon: Icons.check_circle_outline_rounded,
            ),
          ExchangeRejected() => const _InfoBar(
              text: "Échange refusé",
              color: Colors.red,
              icon: Icons.cancel_outlined,
            ),
          ExchangeCompleted() => const _InfoBar(
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
        },
        switch (donationState) {
          DonationPending() => const _InfoBar(
              text: "Une demande de donation est en attente de réponse",
              color: Colors.orange,
              icon: Icons.volunteer_activism_rounded,
            ),
          DonationAccepted() => const _InfoBar(
              text: "Donation acceptée 🎉",
              color: Colors.green,
              icon: Icons.check_circle_outline_rounded,
            ),
          DonationRejected() => const _InfoBar(
              text: "Donation refusée",
              color: Colors.red,
              icon: Icons.cancel_outlined,
            ),
          DonationCompleted() => const _InfoBar(
              text: "Donation terminée ✅",
              color: Colors.blue,
              icon: Icons.task_alt_rounded,
            ),
          DonationInitial() ||
          DonationLoading() ||
          DonationError() =>
            const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _InfoBar extends StatelessWidget {
  const _InfoBar({
    required this.text,
    required this.color,
    required this.icon,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: AppTypo.textXs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
