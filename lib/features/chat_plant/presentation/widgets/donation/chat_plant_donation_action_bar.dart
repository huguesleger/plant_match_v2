import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_action_button.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_action_button_templates.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/common/chat_plant_accept_or_refuse_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/donation/donation_request_dialog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/owner_validation_code.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/validation_code_input.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';

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
    if (plantOfferType != OfferType.donation) return const SizedBox.shrink();

    final bool isPlantOwner = currentUserId == plantOwnerId;

    return switch (state) {
      DonationPending(:final donation) when isPlantOwner =>
        ChatPlantAcceptOrRefuseBar(
          onAccept: () => context.read<DonationCubit>().accept(donation.id),
          onRefuse: () => context.read<DonationCubit>().reject(donation.id),
        ),
      DonationAccepted(:final donation) ||
      DonationWaitingValidation(:final donation) when isPlantOwner =>
        OwnerValidationCode(
          key: ValueKey(donation.id),
          watchCode: () =>
              context.read<DonationCubit>().validationCode(donation.id),
          generate: () =>
              context.read<DonationCubit>().generateCode(donation.id),
        ),
      DonationWaitingValidation(:final donation) when !isPlantOwner =>
        ValidationCodeInput(
          onValidate: (code) => context.read<DonationCubit>().validateCode(
                donation.id,
                code,
                context.read<UserPointsCubit>(),
              ),
        ),
      DonationAccepted() when !isPlantOwner => ChatPlantStatusBanner(
          message: t.chatPlant.view.status.donation_accepted_waiting,
          icon: LucideIcons.calendar_check,
        ),
      DonationInitial() ||
      DonationLoading() ||
      DonationPending() ||
      DonationAccepted() ||
      DonationWaitingValidation() ||
      DonationRejected() ||
      DonationCompleted() ||
      DonationError() =>
        (plantOfferType == OfferType.donation &&
                !isPlantOwner &&
                state is! DonationPending &&
                state is! DonationAccepted &&
                state is! DonationCompleted)
            ? ChatPlantActionButton(
                onPressed: () => _requestDonation(context),
                backgroundColor: AppColors.blueGreen,
                icon: Icons.volunteer_activism_rounded,
                label: t.chatPlant.actions.request_donation_btn,
              )
            : const SizedBox.shrink(),
    };
  }

  Future<void> _requestDonation(BuildContext context) {
    final profilCubit = context.read<ProfilCubit>();
    final donationCubit = context.read<DonationCubit>();
    return showDonationRequestDialog(
      context,
      plantName: plantName,
      plantImage: plantImage,
    ).then(
      (confirmed) => confirmed
          ? donationCubit
              .request(Donation.request(
                chatId: chatId,
                requestedBy: currentUserId,
                ownerId: plantOwnerId,
                plantId: plantId,
                plantName: plantName,
                plantImage: plantImage,
              ))
              .then((_) => profilCubit.refreshLeaves(currentUserId))
          : null,
    );
  }
}
