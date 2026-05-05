import 'package:flutter/material.dart';
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
            title: const Text('Supprimer la conversation'),
            content: const Text('Elle sera supprimée uniquement pour vous.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red),
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
