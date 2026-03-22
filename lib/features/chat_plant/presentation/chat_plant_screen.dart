import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/catalog/data/firebase_catalog_repository.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat/presentation/widget/chat_theme.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/plant_message_card.dart';
import 'package:plant_match_v2/features/donation/domain/entities/donation.dart';
import 'package:plant_match_v2/features/donation/presentation/cubit/donation_cubit.dart';
import 'package:plant_match_v2/features/donation/presentation/state/donation_state.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';
import 'package:plant_match_v2/features/exchange/presentation/exchange_page_route.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/detail_plant.dart';

class ChatPlantScreen extends StatelessWidget {
  const ChatPlantScreen({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantName,
    required this.plantDescription,
    required this.plantImage,
    required this.plantOfferType,
    required this.plantOwnerId,
    required this.plantOwnerName,
    required this.plantOwnerAvatar,
    required this.messages,
  });

  final String chatId;
  final String plantId;
  final String plantName;
  final String plantDescription;
  final String plantImage;
  final OfferType plantOfferType;
  final String plantOwnerId;
  final String plantOwnerName;
  final String plantOwnerAvatar;
  final List<types.Message> messages;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    // ─── États échange ───────────────────────────────────────────────────────
    final exchangeState = context.watch<ExchangeCubit>().state;
    final exchange = switch (exchangeState) {
      ExchangePending(:final exchange) => exchange,
      ExchangeAccepted(:final exchange) => exchange,
      ExchangeRejected(:final exchange) => exchange,
      _ => null,
    };

    // ─── États donation ──────────────────────────────────────────────────────
    final donationState = context.watch<DonationCubit>().state;
    final donation = switch (donationState) {
      DonationPending(:final donation) => donation,
      DonationAccepted(:final donation) => donation,
      DonationRejected(:final donation) => donation,
      DonationCompleted(:final donation) => donation,
      _ => null,
    };

    final bool isPlantOwner = currentUser.uid == plantOwnerId;
    final bool showExchangeAction =
        !isPlantOwner && plantOfferType == OfferType.exchange;
    final bool showDonationAction =
        !isPlantOwner && plantOfferType == OfferType.donation;

    return MultiBlocListener(
      listeners: [
        BlocListener<ChatPlantCubit, ChatPlantState>(
          listener: (context, state) {
            if (state is ChatPlantLoaded) {
              context.read<ChatPlantCubit>().markMessagesAsRead(
                    chatId: chatId,
                    currentUserId: currentUser.uid,
                  );
            }
          },
        ),
        // ─── Listener Échange ────────────────────────────────────────────────
        BlocListener<ExchangeCubit, ExchangeState>(
          listener: (context, state) {
            final ex = switch (state) {
              ExchangePending(:final exchange) => exchange,
              ExchangeAccepted(:final exchange) => exchange,
              ExchangeRejected(:final exchange) => exchange,
              _ => null,
            };
            if (ex == null) return;
            final cubit = context.read<ExchangeCubit>();
            if (currentUser.uid == ex.ownerId && !ex.seenByOwner) {
              cubit.markSeenByOwner(ex.id);
            }
            if (currentUser.uid == ex.requestedBy &&
                !ex.seenByRequester &&
                ex.status != ExchangeStatus.pending) {
              cubit.markSeenByRequester(ex.id);
            }
          },
        ),
        // ─── Listener Donation ───────────────────────────────────────────────
        BlocListener<DonationCubit, DonationState>(
          listener: (context, state) {
            final don = switch (state) {
              DonationPending(:final donation) => donation,
              DonationAccepted(:final donation) => donation,
              DonationRejected(:final donation) => donation,
              DonationCompleted(:final donation) => donation,
              _ => null,
            };
            if (don == null) return;
            final cubit = context.read<DonationCubit>();
            if (currentUser.uid == don.ownerId && !don.seenByOwner) {
              cubit.markSeenByOwner(don.id);
            }
            if (currentUser.uid == don.requestedBy &&
                !don.seenByRequester &&
                don.status != DonationStatus.pending) {
              cubit.markSeenByRequester(don.id);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBarTemplate(
          preferredHeight: 85,
          backgroundColor: AppColors.greenLight,
          surfaceTintColor: Colors.white,
          onPressed: () => Navigator.pop(context),
          styleIconButton: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: AppColors.greyDark),
          ),
          titleWidget: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    plantOwnerAvatar.isNotEmpty && plantOwnerAvatar != 'null'
                        ? NetworkImage(plantOwnerAvatar)
                        : null,
                child: plantOwnerAvatar.isEmpty || plantOwnerAvatar == 'null'
                    ? Text(
                        plantOwnerName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(plantOwnerName),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.greyDark),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Supprimer la conversation'),
                    content: const Text(
                      'Elle sera supprimée uniquement pour vous.',
                    ),
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
                  context.read<ChatPlantCubit>().softDeleteChat(
                        chatId,
                        FirebaseAuth.instance.currentUser!.uid,
                      );
                  if (context.mounted) Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // ─── Info bars Échange ───────────────────────────────────────────
            if (exchangeState is ExchangePending)
              const _InfoBar(
                text: "Une demande d'échange est en attente de réponse",
                color: Colors.orange,
                icon: Icons.swap_horiz_rounded,
              ),
            if (exchangeState is ExchangeAccepted)
              const _InfoBar(
                text: "Échange accepté 🎉",
                color: Colors.green,
                icon: Icons.check_circle_outline_rounded,
              ),
            if (exchangeState is ExchangeRejected)
              const _InfoBar(
                text: "Échange refusé",
                color: Colors.red,
                icon: Icons.cancel_outlined,
              ),
            if (exchangeState is ExchangeCompleted)
              const _InfoBar(
                text: "Échange terminé ✅",
                color: Colors.blue,
                icon: Icons.task_alt_rounded,
              ),

            // ─── Info bars Donation ──────────────────────────────────────────
            if (donationState is DonationPending)
              const _InfoBar(
                text: "Une demande de donation est en attente de réponse",
                color: Colors.orange,
                icon: Icons.volunteer_activism_rounded,
              ),
            if (donationState is DonationAccepted)
              const _InfoBar(
                text: "Donation acceptée 🎉",
                color: Colors.green,
                icon: Icons.check_circle_outline_rounded,
              ),
            if (donationState is DonationRejected)
              const _InfoBar(
                text: "Donation refusée",
                color: Colors.red,
                icon: Icons.cancel_outlined,
              ),
            if (donationState is DonationCompleted)
              const _InfoBar(
                text: "Donation terminée ✅",
                color: Colors.blue,
                icon: Icons.task_alt_rounded,
              ),

            // ─── Chat ────────────────────────────────────────────────────────
            Expanded(
              child: Chat(
                user: types.User(id: currentUser.uid),
                messages: messages,
                theme: ChatThemes.light,
                customMessageBuilder: (types.CustomMessage message,
                    {required int messageWidth}) {
                  final metadata = message.metadata;
                  if (metadata?['messageType'] == 'plant_exchange') {
                    final pId = metadata?['plantId'] as String? ?? '';
                    final pName = metadata?['plantName'] as String? ?? '';
                    final pImage = metadata?['plantImage'] as String? ?? '';
                    final isSender = message.author.id == currentUser.uid;

                    return PlantMessageCard(
                      plantId: pId,
                      plantName: pName,
                      plantImage: pImage,
                      isSender: isSender,
                      onTap: () async {
                        final catalogRepo = FirebaseCatalogRepository();
                        try {
                          final result =
                              await catalogRepo.getCatalogById(pId).run();
                          final catalog = result
                              .map((opt) => opt.toNullable())
                              .getOrElse((_) => null);

                          if (catalog != null && context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPlant(catalog: catalog),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Impossible de charger les détails de la plante'),
                              ),
                            );
                          }
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
                customBottomWidget: Column(
                  children: [
                    // ─── Actions Échange (propriétaire) ─────────────────────
                    if (exchangeState is ExchangePending &&
                        currentUser.uid == plantOwnerId &&
                        exchange != null)
                      _AcceptOrRefuseActionBar(
                        label: "l'échange",
                        onAccept: () =>
                            context.read<ExchangeCubit>().accept(exchange.id),
                        onRefuse: () =>
                            context.read<ExchangeCubit>().reject(exchange.id),
                      ),
                    if (exchangeState is ExchangeAccepted &&
                        currentUser.uid == plantOwnerId &&
                        exchange != null)
                      _CompleteActionButton(
                        label: "l'échange",
                        dialogTitle: "Clôturer l'échange",
                        dialogContent:
                            'Avez-vous effectué l\'échange physique ?\n\n'
                            'Cette action marquera la conversation comme terminée '
                            'et elle sera déplacée dans votre historique d\'échanges.',
                        onConfirm: () => context
                            .read<ExchangeCubit>()
                            .complete(exchange.id, currentUser.uid),
                      ),

                    // ─── Action Échange (demandeur) ──────────────────────────
                    if (showExchangeAction &&
                        exchangeState is! ExchangePending &&
                        exchangeState is! ExchangeAccepted &&
                        exchangeState is! ExchangeCompleted)
                      _ExchangeActionBar(
                        onExchangePressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExchangePageRoute(
                                chatId: chatId,
                                targetPlantId: plantId,
                                targetOwnerId: plantOwnerId,
                              ),
                            ),
                          );
                        },
                      ),

                    // ─── Actions Donation (propriétaire) ────────────────────
                    if (donationState is DonationPending &&
                        currentUser.uid == plantOwnerId &&
                        donation != null)
                      _AcceptOrRefuseActionBar(
                        label: 'la donation',
                        onAccept: () =>
                            context.read<DonationCubit>().accept(donation.id),
                        onRefuse: () =>
                            context.read<DonationCubit>().reject(donation.id),
                      ),
                    if (donationState is DonationAccepted &&
                        currentUser.uid == plantOwnerId &&
                        donation != null)
                      _CompleteActionButton(
                        label: 'la donation',
                        dialogTitle: 'Clôturer la donation',
                        dialogContent:
                            'Avez-vous remis la plante au bénéficiaire ?\n\n'
                            'Cette action marquera la conversation comme terminée '
                            'et archivera la plante.',
                        onConfirm: () => context
                            .read<DonationCubit>()
                            .complete(donation.id, currentUser.uid),
                      ),

                    // ─── Action Donation (demandeur) ─────────────────────────
                    if (showDonationAction &&
                        donationState is! DonationPending &&
                        donationState is! DonationAccepted &&
                        donationState is! DonationCompleted)
                      _DonationRequestBar(
                        onPressed: () {
                          _showDonationConfirmDialog(
                            context: context,
                            currentUserId: currentUser.uid,
                            plantId: plantId,
                            plantName: plantName,
                            plantImage: plantImage,
                            ownerId: plantOwnerId,
                          );
                        },
                      ),

                    _ChatTextInput(
                      onSend: (text) {
                        context.read<ChatPlantCubit>().send(
                              chatId: chatId,
                              senderId: currentUser.uid,
                              text: text,
                            );
                      },
                    ),
                  ],
                ),
                onSendPressed: (types.PartialText message) {
                  context.read<ChatPlantCubit>().send(
                        chatId: chatId,
                        senderId: currentUser.uid,
                        text: message.text,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialogue de confirmation avant de créer une demande de donation
  void _showDonationConfirmDialog({
    required BuildContext context,
    required String currentUserId,
    required String plantId,
    required String plantName,
    required String plantImage,
    required String ownerId,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Demander cette plante'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (plantImage.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  plantImage,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              'Souhaitez-vous envoyer une demande de donation pour "$plantName" ?',
              textAlign: TextAlign.center,
              style: InterTextStyle.inter(AppTypo.textS,
                  color: AppColors.greyDark),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<DonationCubit>().request(
                    Donation(
                      chatId: chatId,
                      requestedBy: currentUserId,
                      ownerId: ownerId,
                      plantId: plantId,
                      plantName: plantName,
                      plantImage: plantImage,
                      status: DonationStatus.pending,
                      createdAt: DateTime.now(),
                      seenByOwner: false,
                      seenByRequester: true,
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenDark,
              foregroundColor: Colors.white,
            ),
            child: const Text('Envoyer la demande'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets privés
// ─────────────────────────────────────────────────────────────────────────────

/// Barre d'information colorée (échange ou donation)
class _InfoBar extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _InfoBar({
    required this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: AppTypo.textXs,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Barre Accepter / Refuser (réutilisée pour échange ET donation)
class _AcceptOrRefuseActionBar extends StatelessWidget {
  const _AcceptOrRefuseActionBar({
    required this.label,
    required this.onAccept,
    required this.onRefuse,
  });

  final String label;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ButtonRounded(
              onPressed: onAccept,
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: 'Accepter',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ButtonOutlinedRounded(
              onPressed: onRefuse,
              borderColor: AppColors.blueGreen,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: 'Refuser',
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton "Clôturer" générique (échange ou donation)
class _CompleteActionButton extends StatelessWidget {
  const _CompleteActionButton({
    required this.label,
    required this.dialogTitle,
    required this.dialogContent,
    required this.onConfirm,
  });

  final String label;
  final String dialogTitle;
  final String dialogContent;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: OutlinedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(dialogTitle),
              content: Text(dialogContent),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.check_circle_outline, size: 20),
        label: Text('Marquer $label comme terminée'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green.shade700,
          side: BorderSide(color: Colors.green.shade300),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

/// Barre "Proposer un échange" (demandeur, plante type échange)
class _ExchangeActionBar extends StatelessWidget {
  const _ExchangeActionBar({required this.onExchangePressed});

  final VoidCallback onExchangePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: ElevatedButton.icon(
        onPressed: onExchangePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenDark,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(LucideIcons.heart_handshake, color: Colors.white),
        label: const Text(
          'Proposer un échange',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppTypo.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Barre "Demander cette plante" (demandeur, plante type donation)
class _DonationRequestBar extends StatelessWidget {
  const _DonationRequestBar({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyLight)),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueGreen,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.volunteer_activism_rounded, color: Colors.white),
        label: const Text(
          'Demander cette plante',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppTypo.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Input texte du chat
class _ChatTextInput extends StatefulWidget {
  const _ChatTextInput({required this.onSend});

  final void Function(String text) onSend;

  @override
  State<_ChatTextInput> createState() => _ChatTextInputState();
}

class _ChatTextInputState extends State<_ChatTextInput> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.greyLight)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Écrire un message…',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.greenMedium.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.send_horizontal,
                  color: AppColors.greenDark,
                ),
              ),
              onPressed: _handleSend,
            ),
          ],
        ),
      ),
    );
  }
}
