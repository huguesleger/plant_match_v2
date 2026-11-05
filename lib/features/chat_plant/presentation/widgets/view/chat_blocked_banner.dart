import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/dialog/confirm_dialog.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';

class ChatBlockedBanner extends StatelessWidget {
  const ChatBlockedBanner({
    super.key,
    required this.blockedUserId,
    required this.blockedByMe,
  });

  final String blockedUserId;
  final bool blockedByMe;

  Future<void> _onUnblock(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: t.chatPlant.view.unblock_dialog.title,
      content: Text(t.chatPlant.view.unblock_dialog.content),
      confirmLabel: t.chatPlant.view.unblock_dialog.confirm,
    );
    if (confirmed && context.mounted) {
      context.read<ChatPlantCubit>().unblockUser(
            blockerUserId: context.read<AuthCubit>().userId.getOrElse(() => ''),
            blockedUserId: blockedUserId,
          );
    }
  }

  @override
  Widget build(BuildContext context) => Container(
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
                  style: const TextStyle(color: AppColors.grey, fontSize: 13),
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
