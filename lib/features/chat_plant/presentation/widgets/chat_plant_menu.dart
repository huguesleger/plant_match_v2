import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
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

  String get _currentUserId => FirebaseAuth.instance.currentUser!.uid;

  Future<void> _onDeleteChat(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer la conversation'),
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
      context.read<ChatPlantCubit>().softDeleteChat(chatId, _currentUserId);
      Navigator.pop(context);
    }
  }

  Future<void> _onReport(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signaler'),
        content: const Text(
          'Cette conversation sera transmise à l\'équipe PlantMatch pour examen. Merci de nous aider à maintenir une communauté saine.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Signaler'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<ChatPlantCubit>().reportChat(
            chatId: chatId,
            reporterUserId: _currentUserId,
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
        title: const Text('Bloquer cet utilisateur ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cette personne ne pourra plus vous envoyer de messages ni voir votre profil.',
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
                child: const Row(
                  children: [
                    Icon(LucideIcons.triangle_alert, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Attention : un échange est en cours. Bloquer cet utilisateur notifiera l\'équipe PlantMatch et aucun point ne sera distribué.',
                        style: TextStyle(
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
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Bloquer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<ChatPlantCubit>().blockUser(
            blockerUserId: _currentUserId,
            blockedUserId: plantOwnerId,
          );
    }
  }

  Future<void> _onUnblock(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Débloquer cet utilisateur ?'),
        content: const Text(
          'Cette personne pourra à nouveau vous envoyer des messages.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Débloquer'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      context.read<ChatPlantCubit>().unblockUser(
            blockerUserId: _currentUserId,
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
          child: const Text('Voir le profil'),
        ),
        MenuItemButton(
          onPressed: () => _onReport(context),
          child: const Text('Signaler'),
        ),
        isBlocked
            ? MenuItemButton(
                onPressed: () => _onUnblock(context),
                child: const Text('Débloquer'),
              )
            : MenuItemButton(
                onPressed: () => _onBlock(context),
                child: const Text('Bloquer'),
              ),
        MenuItemButton(
          onPressed: () => _onDeleteChat(context),
          child: const Text('Effacer la conversation'),
        ),
      ],
    );
  }
}
