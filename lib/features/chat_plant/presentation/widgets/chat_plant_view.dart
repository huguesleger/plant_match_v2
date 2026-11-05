import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_custom_message.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_theme.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/donation/chat_plant_donation_info_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/exchange/chat_plant_exchange_info_bar.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/view/chat_bubble.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/view/chat_date_header.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/view/chat_plant_bottom_bar.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';

class ChatPlantView extends StatelessWidget {
  const ChatPlantView({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plant,
    required this.otherUserId,
    required this.messages,
    this.blockStatus = BlockStatus.none,
  });

  final String chatId;
  final String plantId;
  final Catalog plant;
  final String otherUserId;
  final List<types.Message> messages;
  final BlockStatus blockStatus;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId.getOrElse(() => '');
    final exchangeState = context.watch<ExchangeCubit>().state;
    final donationState = context.watch<DonationCubit>().state;
    const hintStyle = TextStyle(color: AppColors.grey, fontSize: AppTypo.text);

    return Column(
      children: [
        ChatPlantExchangeInfoBar(state: exchangeState),
        ChatPlantDonationInfoBar(state: donationState),
        Expanded(
          child: Chat(
            user: types.User(id: userId),
            messages: messages,
            theme: ChatThemes.light,
            emptyState: Center(
              child: Text(
                t.chatPlant.view.empty_messages,
                textAlign: TextAlign.center,
                style: hintStyle,
              ),
            ),
            customMessageBuilder: (message, {required int messageWidth}) =>
                ChatPlantCustomMessage(message: message, currentUserId: userId),
            customBottomWidget: ChatPlantBottomBar(
              chatId: chatId,
              plantId: plantId,
              plant: plant,
              otherUserId: otherUserId,
              currentUserId: userId,
              exchangeState: exchangeState,
              donationState: donationState,
              blockStatus: blockStatus,
            ),
            onSendPressed: (_) {},
            textMessageBuilder: (message,
                    {required int messageWidth, required bool showName}) =>
                Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                message.text,
                style: message.author.id == userId
                    ? ChatThemes.light.sentMessageBodyTextStyle
                    : ChatThemes.light.receivedMessageBodyTextStyle,
              ),
            ),
            dateHeaderBuilder: (date) => ChatDateHeader(date: date.dateTime),
            dateHeaderThreshold: const Duration(days: 1).inMilliseconds,
            bubbleBuilder: (child,
                    {required message, required nextMessageInGroup}) =>
                ChatBubble(message: message, currentUserId: userId, child: child),
          ),
        ),
      ],
    );
  }
}
