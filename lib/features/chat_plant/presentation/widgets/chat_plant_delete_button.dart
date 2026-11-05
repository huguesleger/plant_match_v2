import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/dialog/confirm_dialog.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';

class ChatPlantDeleteButton extends StatelessWidget {
  const ChatPlantDeleteButton({
    super.key,
    required this.chatId,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: AppColors.greyDark),
      onPressed: () async {
        final confirmed = await showConfirmDialog(
          context,
          title: t.chatPlant.menu.delete_dialog.title,
          content: Text(t.chatPlant.menu.delete_dialog.content),
          confirmLabel: t.chatPlant.menu.delete,
          destructive: true,
        );
        if (confirmed && context.mounted) {
          final uid =
              context.read<AuthCubit>().userId.getOrElse(() => '');
          context.read<ChatPlantCubit>().softDeleteChat(
                chatId,
                uid,
              );
          Navigator.pop(context);
        }
      },
    );
  }
}
