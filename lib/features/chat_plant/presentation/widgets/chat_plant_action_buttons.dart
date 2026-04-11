import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_page_route.dart';

class ChatPlantAcceptOrRefuseBar extends StatelessWidget {
  const ChatPlantAcceptOrRefuseBar({
    super.key,
    required this.label,
    required this.onAccept,
    required this.onRefuse,
  });

  final String label;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ButtonRounded(
              onPressed: onAccept,
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: 'Accepter',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ButtonOutlinedRounded(
              onPressed: onRefuse,
              borderColor: AppColors.blueGreen,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: 'Refuser',
            ),
          ),
        ],
      ),
    );
  }
}

class ChatPlantCompleteActionBar extends StatelessWidget {
  const ChatPlantCompleteActionBar({
    super.key,
    required this.label,
    required this.dialogTitle,
    required this.dialogContent,
    required this.onConfirm,
  });

  final String label;
  final String dialogTitle;
  final String dialogContent;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(dialogTitle),
              content: Text(dialogContent),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.check_circle_outline, size: 20),
        label: Text('Marquer $label comme terminée'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green.shade700,
          side: BorderSide(color: Colors.green.shade300),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class ChatPlantExchangeActionBar extends StatelessWidget {
  const ChatPlantExchangeActionBar({
    super.key,
    required this.chatId,
    required this.targetPlantId,
    required this.targetOwnerId,
  });

  final String chatId;
  final String targetPlantId;
  final String targetOwnerId;

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
              targetPlantId: targetPlantId,
              targetOwnerId: targetOwnerId,
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

class ChatPlantDonationRequestBar extends StatelessWidget {
  const ChatPlantDonationRequestBar({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueGreen,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.volunteer_activism_rounded, color: Colors.white),
        label: const Text(
          'Demander cette plante',
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

void showDonationConfirmDialog({
  required BuildContext context,
  required String chatId,
  required String currentUserId,
  required String plantId,
  required String plantName,
  required String plantImage,
  required String ownerId,
}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Demander cette plante'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (plantImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                plantImage,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Souhaitez-vous envoyer une demande de donation pour "$plantName" ?',
            textAlign: TextAlign.center,
            style: InterTextStyle.inter(AppTypo.textS, color: AppColors.greyDark),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            context.read<DonationCubit>().request(
                  Donation(
                    chatId: chatId,
                    requestedBy: currentUserId,
                    ownerId: ownerId,
                    plantId: plantId,
                    plantName: plantName,
                    plantImage: plantImage,
                    status: DonationStatus.pending,
                    createdAt: DateTime.now(),
                    seenByOwner: false,
                    seenByRequester: true,
                  ),
                );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.greenDark,
            foregroundColor: Colors.white,
          ),
          child: const Text('Envoyer la demande'),
        ),
      ],
    ),
  );
}
