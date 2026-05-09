import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';
import 'package:plant_match_v2/features/user/presentation/user_page_route.dart';

class ChatPlantMenu extends StatelessWidget {
  const ChatPlantMenu({
    super.key,
    required this.chatId,
    required this.plantOwnerId,
  });

  final String chatId;
  final String plantOwnerId;

  String _currentUserId(BuildContext context) =>
      context.read<AuthCubit>().userId ?? '';

  Future<void> _onDeleteChat(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.chatPlant.menu.delete_dialog.title),
        content: Text(t.chatPlant.menu.delete_dialog.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.chatPlant.menu.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              t.chatPlant.menu.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context
          .read<ChatPlantCubit>()
          .softDeleteChat(chatId, _currentUserId(context));
      Navigator.pop(context);
    }
  }

  Future<void> _onReport(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.chatPlant.menu.report_dialog.title),
        content: Text(
          t.chatPlant.menu.report_dialog.content,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.chatPlant.menu.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.chatPlant.menu.report),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<ChatPlantCubit>().reportChat(
            chatId: chatId,
            reporterUserId: _currentUserId(context),
            reportedUserId: plantOwnerId,
          );
    }
  }

  Future<void> _onBlock(BuildContext context) async {
    final exchangeState = context.read<ExchangeCubit>().state;
    final donationState = context.read<DonationCubit>().state;

    final bool isTransactionActive = (exchangeState is ExchangeAccepted ||
            exchangeState is ExchangeWaitingValidation) ||
        (donationState is DonationAccepted ||
            donationState is DonationWaitingValidation);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.chatPlant.view.unblock_dialog.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.chatPlant.menu.block_dialog.content,
            ),
            if (isTransactionActive) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child:  Row(
                  children: [
                    const Icon(LucideIcons.triangle_alert, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.chatPlant.menu.block_dialog.warning_active_transaction,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.chatPlant.menu.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              t.chatPlant.menu.block,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<ChatPlantCubit>().blockUser(
            blockerUserId: _currentUserId(context),
            blockedUserId: plantOwnerId,
          );
    }
  }

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
            child: Text(t.chatPlant.menu.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t.chatPlant.menu.unblock),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<ChatPlantCubit>().unblockUser(
            blockerUserId: _currentUserId(context),
            blockedUserId: plantOwnerId,
          );
    }
  }

  void _onViewProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserPageRoute(uid: plantOwnerId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ChatPlantCubit>().state;
    final isBlocked = switch (state) {
      ChatPlantLoaded(:final isBlocked) => isBlocked,
      _ => false,
    };

    return MenuAnchor(
      style: const MenuStyle(
        alignment: Alignment.bottomRight,
        backgroundColor: WidgetStatePropertyAll(AppColors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: AppColors.greyLight),
          ),
        ),
      ),
      alignmentOffset: const Offset(-170, 10),
      builder: (context, controller, child) => IconButton(
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        icon: const Icon(LucideIcons.ellipsis_vertical),
        onPressed: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () => _onViewProfile(context),
          child: Text(t.chatPlant.menu.see_profile),
        ),
        MenuItemButton(
          onPressed: () => _onReport(context),
          child: Text(t.chatPlant.menu.report),
        ),
        isBlocked
            ? MenuItemButton(
                onPressed: () => _onUnblock(context),
                child: Text(t.chatPlant.menu.unblock),
              )
            : MenuItemButton(
                onPressed: () => _onBlock(context),
                child: Text(t.chatPlant.menu.block),
              ),
        MenuItemButton(
          onPressed: () => _onDeleteChat(context),
          child: Text(t.chatPlant.menu.clear_chat),
        ),
      ],
    );
  }
}
