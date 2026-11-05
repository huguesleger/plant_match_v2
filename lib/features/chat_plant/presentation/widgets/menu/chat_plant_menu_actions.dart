import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/dialog/confirm_dialog.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/menu/block_transaction_warning.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

class ChatPlantMenuActions {
  const ChatPlantMenuActions(
    this.context, {
    required this.chatId,
    required this.otherUserId,
  });

  final BuildContext context;
  final String chatId;
  final String otherUserId;

  String _currentUserId() =>
      context.read<AuthCubit>().userId.getOrElse(() => '');

  bool _hasActiveTransaction() {
    final exchange = context.read<ExchangeCubit>().state;
    final donation = context.read<DonationCubit>().state;
    return exchange is ExchangeAccepted ||
        exchange is ExchangeWaitingValidation ||
        donation is DonationAccepted ||
        donation is DonationWaitingValidation;
  }

  Future<void> _confirmThen({
    required String title,
    required Widget content,
    required String confirmLabel,
    required void Function(ChatPlantCubit cubit, String userId) onConfirm,
    bool destructive = false,
  }) async {
    final confirmed = await showConfirmDialog(
      context,
      title: title,
      content: content,
      confirmLabel: confirmLabel,
      destructive: destructive,
    );
    if (confirmed && context.mounted) {
      onConfirm(context.read<ChatPlantCubit>(), _currentUserId());
    }
  }

  void onDeleteChat() => _confirmThen(
        title: t.chatPlant.menu.delete_dialog.title,
        content: Text(t.chatPlant.menu.delete_dialog.content),
        confirmLabel: t.chatPlant.menu.delete,
        destructive: true,
        onConfirm: (cubit, userId) {
          cubit.softDeleteChat(chatId, userId);
          Navigator.pop(context);
        },
      );

  void onReport() => _confirmThen(
        title: t.chatPlant.menu.report_dialog.title,
        content: Text(t.chatPlant.menu.report_dialog.content),
        confirmLabel: t.chatPlant.menu.report,
        onConfirm: (cubit, userId) => cubit.reportChat(
          chatId: chatId,
          reporterUserId: userId,
          reportedUserId: otherUserId,
        ),
      );

  void onBlock() => _confirmThen(
        title: t.chatPlant.menu.block_dialog.title,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.chatPlant.menu.block_dialog.content),
            if (_hasActiveTransaction()) ...[
              const SizedBox(height: 16),
              const BlockTransactionWarning(),
            ],
          ],
        ),
        confirmLabel: t.chatPlant.menu.block,
        destructive: true,
        onConfirm: (cubit, userId) => cubit.blockUser(
          blockerUserId: userId,
          blockedUserId: otherUserId,
        ),
      );

  void onUnblock() => _confirmThen(
        title: t.chatPlant.view.unblock_dialog.title,
        content: Text(t.chatPlant.view.unblock_dialog.content),
        confirmLabel: t.chatPlant.menu.unblock,
        onConfirm: (cubit, userId) => cubit.unblockUser(
          blockerUserId: userId,
          blockedUserId: otherUserId,
        ),
      );
}
