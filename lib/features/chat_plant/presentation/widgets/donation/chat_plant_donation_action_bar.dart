import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_action_button_templates.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';

class ChatPlantDonationActionBar extends StatelessWidget {
  const ChatPlantDonationActionBar({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.plantOwnerId,
    required this.plantOfferType,
    required this.currentUserId,
    required this.state,
  });

  final String chatId;
  final String plantId;
  final String plantName;
  final String plantImage;
  final String plantOwnerId;
  final OfferType plantOfferType;
  final String currentUserId;
  final DonationState state;

  @override
  Widget build(BuildContext context) {
    final bool isPlantOwner = currentUserId == plantOwnerId;

    return switch (state) {
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
                state is! DonationPending &&
                state is! DonationAccepted &&
                state is! DonationCompleted)
            ? _DonationRequestButton(
                onPressed: () => _showDonationConfirmDialog(
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
    };
  }

  void _showDonationConfirmDialog({
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
              style:
                  InterTextStyle.inter(AppTypo.textS, color: AppColors.greyDark),
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
}

class _DonationRequestButton extends StatelessWidget {
  const _DonationRequestButton({
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
