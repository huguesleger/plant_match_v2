import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_info_bar_template.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';

class ChatPlantDonationInfoBar extends StatelessWidget {
  const ChatPlantDonationInfoBar({
    super.key,
    required this.state,
  });

  final DonationState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      DonationPending() => ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.donation.pending,
          color: Colors.orange,
          icon: Icons.volunteer_activism_rounded,
        ),
      DonationAccepted() || DonationWaitingValidation() =>
        ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.donation.accepted,
          color: Colors.green,
          icon: Icons.check_circle_outline_rounded,
        ),
      DonationRejected() => ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.donation.rejected,
          color: Colors.red,
          icon: Icons.cancel_outlined,
        ),
      DonationCompleted() => ChatPlantInfoBarTemplate(
          text: t.chatPlant.info_bar.donation.completed,
          color: Colors.blue,
          icon: Icons.task_alt_rounded,
        ),
      DonationInitial() ||
      DonationLoading() ||
      DonationError() =>
        const SizedBox.shrink(),
    };
  }
}
