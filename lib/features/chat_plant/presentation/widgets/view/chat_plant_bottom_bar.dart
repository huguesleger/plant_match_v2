import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_text_input.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/donation/chat_plant_donation_action_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/exchange/chat_plant_exchange_action_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/view/chat_blocked_banner.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ChatPlantBottomBar extends StatelessWidget {
  const ChatPlantBottomBar({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plant,
    required this.otherUserId,
    required this.currentUserId,
    required this.exchangeState,
    required this.donationState,
    required this.blockStatus,
  });

  final String chatId;
  final String plantId;
  final Catalog plant;
  final String otherUserId;
  final String currentUserId;
  final ExchangeState exchangeState;
  final DonationState donationState;
  final BlockStatus blockStatus;

  void _send(BuildContext context, String text) {
    final profilCubit = context.read<ProfilCubit>();
    final messenger = ScaffoldMessenger.of(context);
    context
        .read<ChatPlantCubit>()
        .send(chatId: chatId, senderId: currentUserId, text: text)
        .then((error) {
      profilCubit.refreshLeaves(currentUserId);
      error.map(
        (failure) => messenger.showSnackBar(
          SnackBar(content: Text(failure.errorContent.message)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ChatPlantExchangeActionBar(
            chatId: chatId,
            plantId: plantId,
            plantOwnerId: plant.userId,
            plantOfferType: plant.offerType,
            currentUserId: currentUserId,
            state: exchangeState,
          ),
          ChatPlantDonationActionBar(
            chatId: chatId,
            plantId: plantId,
            plantName: plant.name,
            plantImage: plant.images.isNotEmpty ? plant.images.first : '',
            plantOwnerId: plant.userId,
            plantOfferType: plant.offerType,
            currentUserId: currentUserId,
            state: donationState,
          ),
          switch (blockStatus) {
            BlockStatus.none => ChatPlantTextInput(
              onSend: (text) => _send(context, text),
            ),
            BlockStatus.blockedByMe ||
            BlockStatus.blockedByOther =>
              ChatBlockedBanner(
                blockedUserId: otherUserId,
                blockedByMe: blockStatus == BlockStatus.blockedByMe,
              ),
          },
        ],
      );
}
