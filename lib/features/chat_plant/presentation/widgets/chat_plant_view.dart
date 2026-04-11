import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_custom_message.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_text_input.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_theme.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/donation/chat_plant_donation_action_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/donation/chat_plant_donation_info_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/exchange/chat_plant_exchange_action_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/exchange/chat_plant_exchange_info_bar.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';

class ChatPlantView extends StatelessWidget {
  const ChatPlantView({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.plantOwnerId,
    required this.plantOwnerName,
    required this.plantOfferType,
    required this.messages,
  });

  final String chatId;
  final String plantId;
  final String plantName;
  final String plantImage;
  final String plantOwnerId;
  final String plantOwnerName;
  final OfferType plantOfferType;
  final List<types.Message> messages;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final exchangeState = context.watch<ExchangeCubit>().state;
    final donationState = context.watch<DonationCubit>().state;

    return Column(
      children: [
        ChatPlantExchangeInfoBar(state: exchangeState),
        ChatPlantDonationInfoBar(state: donationState),
        Expanded(
          child: Chat(
            user: types.User(id: currentUser.uid),
            messages: messages,
            theme: ChatThemes.light,
            customMessageBuilder: (message, {required int messageWidth}) =>
                ChatPlantCustomMessage(
              message: message,
              currentUserId: currentUser.uid,
            ),
            customBottomWidget: Column(
              children: [
                ChatPlantExchangeActionBar(
                  chatId: chatId,
                  plantId: plantId,
                  plantOwnerId: plantOwnerId,
                  plantOfferType: plantOfferType,
                  currentUserId: currentUser.uid,
                  state: exchangeState,
                ),
                ChatPlantDonationActionBar(
                  chatId: chatId,
                  plantId: plantId,
                  plantName: plantName,
                  plantImage: plantImage,
                  plantOwnerId: plantOwnerId,
                  plantOfferType: plantOfferType,
                  currentUserId: currentUser.uid,
                  state: donationState,
                ),
                ChatPlantTextInput(
                  onSend: (text) => context.read<ChatPlantCubit>().send(
                        chatId: chatId,
                        senderId: currentUser.uid,
                        text: text,
                      ),
                ),
              ],
            ),
            onSendPressed: (message) => context.read<ChatPlantCubit>().send(
                  chatId: chatId,
                  senderId: currentUser.uid,
                  text: message.text,
                ),
          ),
        ),
      ],
    );
  }
}
