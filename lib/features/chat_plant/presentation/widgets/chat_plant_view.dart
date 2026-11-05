import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/util/date_formatter.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_custom_message.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/chat_plant_text_input.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
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
    required this.otherUserId,
    required this.plantOwnerName,
    required this.plantOfferType,
    required this.messages,
    this.blockStatus = BlockStatus.none,
  });

  final String chatId;
  final String plantId;
  final String plantName;
  final String plantImage;
  final String plantOwnerId;
  final String otherUserId;
  final String plantOwnerName;
  final OfferType plantOfferType;
  final List<types.Message> messages;
  final BlockStatus blockStatus;

  void _send(BuildContext context, String userId, String text) {
    final profilCubit = context.read<ProfilCubit>();
    final messenger = ScaffoldMessenger.of(context);
    context
        .read<ChatPlantCubit>()
        .send(chatId: chatId, senderId: userId, text: text)
        .then((error) {
      profilCubit.refreshLeaves(userId);
      error.map(
        (message) => messenger.showSnackBar(
          SnackBar(content: Text(t.chatPlant.view.send_error(error: message))),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId.getOrElse(() => '');
    final exchangeState = context.watch<ExchangeCubit>().state;
    final donationState = context.watch<DonationCubit>().state;

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
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: AppTypo.text,
                ),
              ),
            ),
            customMessageBuilder: (message, {required int messageWidth}) =>
                ChatPlantCustomMessage(
              message: message,
              currentUserId: userId,
            ),
            customBottomWidget: Column(
              children: [
                ChatPlantExchangeActionBar(
                  chatId: chatId,
                  plantId: plantId,
                  plantOwnerId: plantOwnerId,
                  plantOfferType: plantOfferType,
                  currentUserId: userId,
                  state: exchangeState,
                ),
                ChatPlantDonationActionBar(
                  chatId: chatId,
                  plantId: plantId,
                  plantName: plantName,
                  plantImage: plantImage,
                  plantOwnerId: plantOwnerId,
                  plantOfferType: plantOfferType,
                  currentUserId: userId,
                  state: donationState,
                ),
                blockStatus != BlockStatus.none
                    ? _BlockedBanner(
                        blockedUserId: otherUserId,
                        blockedByMe: blockStatus == BlockStatus.blockedByMe,
                      )
                    : ChatPlantTextInput(
                        onSend: (text) => _send(context, userId, text),
                      ),
              ],
            ),
            onSendPressed: (message) => _send(context, userId, message.text),
            textMessageBuilder: (types.TextMessage message,
                {required int messageWidth, required bool showName}) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  message.text,
                  style: message.author.id == userId
                      ? ChatThemes.light.sentMessageBodyTextStyle
                      : ChatThemes.light.receivedMessageBodyTextStyle,
                ),
              );
            },
            dateHeaderBuilder: (date) => Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  DateFormatter.format(context, date.dateTime, isHeader: true),
                  style: const TextStyle(
                    color: AppColors.greyMedium,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            dateHeaderThreshold: 86400000,
            bubbleBuilder: (child,
                {required message, required nextMessageInGroup}) {
              final isCurrentUser = message.author.id == userId;

              final time = DateFormatter.formatTime(
                context,
                DateTime.fromMillisecondsSinceEpoch(
                    Option.fromNullable(message.createdAt).getOrElse(() => 0)),
              );

              final bool isCustom = message is types.CustomMessage;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isCustom)
                    child
                  else
                    Container(
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? ChatThemes.light.primaryColor
                            : ChatThemes.light.secondaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(isCurrentUser ? 12 : 0),
                          bottomRight: Radius.circular(isCurrentUser ? 0 : 12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          child,
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0,
                              bottom: 4,
                              left: 12,
                              right: 12,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.greyDark
                                        .withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (isCurrentUser) ...[
                                  const SizedBox(width: 4),
                                  _StatusIcon(
                                    status: Option.fromNullable(message.status),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});
  final Option<types.Status> status;

  @override
  Widget build(BuildContext context) {
    return status.match(
      () => const SizedBox.shrink(),
      (status) => switch (status) {
        types.Status.delivered =>
          const Icon(LucideIcons.check_check, size: 12, color: Colors.grey),
        types.Status.seen => const Icon(LucideIcons.check_check,
            size: 12, color: AppColors.blueGreen),
        types.Status.sent =>
          const Icon(LucideIcons.check, size: 12, color: Colors.grey),
        types.Status.sending =>
          const Icon(LucideIcons.clock, size: 10, color: Colors.grey),
        types.Status.error =>
          const Icon(LucideIcons.circle_alert, size: 12, color: Colors.red),
      },
    );
  }
}

class _BlockedBanner extends StatelessWidget {
  const _BlockedBanner({
    required this.blockedUserId,
    required this.blockedByMe,
  });

  final String blockedUserId;
  final bool blockedByMe;

  String _currentUserId(BuildContext context) =>
      context.read<AuthCubit>().userId.getOrElse(() => '');

  Future<void> _onUnblock(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.chatPlant.view.unblock_dialog.title),
        content: Text(
          t.chatPlant.view.unblock_dialog.content,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.chatPlant.view.unblock_dialog.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.chatPlant.view.unblock_dialog.confirm),
          ),
        ],
      ),
    );
    if (Option.fromNullable(confirm).getOrElse(() => false) &&
        context.mounted) {
      context.read<ChatPlantCubit>().unblockUser(
            blockerUserId: _currentUserId(context),
            blockedUserId: blockedUserId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.ban, size: 16, color: AppColors.grey),
              const SizedBox(width: 8),
              Text(
                blockedByMe
                    ? t.chatPlant.view.blocked_user_banner
                    : t.chatPlant.view.blocked_by_other_banner,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                ),
              ),
              if (blockedByMe) ...[
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _onUnblock(context),
                  child: Text(
                    t.chatPlant.view.unblock_btn,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenDark,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
