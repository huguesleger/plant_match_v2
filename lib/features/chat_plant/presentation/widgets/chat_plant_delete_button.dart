import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
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
          final uid = context.read<AuthCubit>().userId ?? '';
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
