import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat/presentation/widget/chat_theme.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/exchange/domain/entities/exchange.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_cubit.dart';

import 'package:plant_match_v2/features/exchange/presentation/exchange_page.dart';
import 'package:plant_match_v2/features/exchange/presentation/state/exchange_state.dart';

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

    context.read<ExchangeCubit>().listen(chatId);

    final exchangeState = context.watch<ExchangeCubit>().state;

    final exchange = switch (exchangeState) {
      ExchangePending(:final exchange) => exchange,
      ExchangeAccepted(:final exchange) => exchange,
      ExchangeRejected(:final exchange) => exchange,
      _ => null,
    };

    final bool isPlantOwner = currentUser.uid == plantOwnerId;
    final bool showExchangeAction =
        !isPlantOwner && plantOfferType == OfferType.exchange;

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
        BlocListener<ExchangeCubit, ExchangeState>(
          listener: (context, state) {
            final exchange = switch (state) {
              ExchangePending(:final exchange) => exchange,
              ExchangeAccepted(:final exchange) => exchange,
              ExchangeRejected(:final exchange) => exchange,
              _ => null,
            };

            if (exchange == null) return;

            final cubit = context.read<ExchangeCubit>();

            if (currentUser.uid == exchange.ownerId && !exchange.seenByOwner) {
              cubit.markSeenByOwner(exchange.id);
            }

            if (currentUser.uid == exchange.requestedBy &&
                !exchange.seenByRequester &&
                exchange.status != ExchangeStatus.pending) {
              cubit.markSeenByRequester(exchange.id);
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
                  await context.read<ChatPlantCubit>().softDeleteChat(
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
            if (exchangeState is ExchangePending)
              const _ExchangeInfoBar(
                text: "Une demande d’échange est en attente de réponse",
                color: Colors.orange,
              ),
            if (exchangeState is ExchangeAccepted)
              const _ExchangeInfoBar(
                text: "Échange accepté 🎉",
                color: Colors.green,
              ),
            if (exchangeState is ExchangeRejected)
              const _ExchangeInfoBar(
                text: "Échange refusé",
                color: Colors.red,
              ),
            Expanded(
              child: Chat(
                user: types.User(id: currentUser.uid),
                messages: messages,
                theme: ChatThemes.light,
                customBottomWidget: Column(
                  children: [
                    if (exchangeState is ExchangePending &&
                        currentUser.uid == plantOwnerId &&
                        exchange != null)
                      _ExchangeAcceptOrRefuseActionBar(
                        onExchangeAcceptPressed: () {
                          context.read<ExchangeCubit>().accept(exchange.id);
                        },
                        onExchangeRefusePressed: () {
                          context.read<ExchangeCubit>().reject(exchange.id);
                        },
                      ),
                    if (showExchangeAction &&
                        exchangeState is! ExchangePending &&
                        exchangeState is! ExchangeAccepted)
                      _ExchangeActionBar(
                        onExchangePressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ExchangePage(
                                chatId: chatId,
                                targetPlantId: plantId,
                                targetOwnerId: plantOwnerId,
                              ),
                            ),
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
}

class _DonationActionBar extends StatelessWidget {
  const _DonationActionBar({
    required this.onDonatePressed,
  });

  final VoidCallback onDonatePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.greyLight),
        ),
      ),
      child: ElevatedButton.icon(
        onPressed: onDonatePressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.greenDark,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(
          LucideIcons.gift,
          color: Colors.white,
        ),
        label: const Text(
          'Proposer un don',
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

class _ExchangeActionBar extends StatelessWidget {
  const _ExchangeActionBar({
    required this.onExchangePressed,
  });

  final VoidCallback onExchangePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.greyLight),
        ),
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
        icon: const Icon(
          LucideIcons.heart_handshake,
          color: Colors.white,
        ),
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

class _ExchangeAcceptOrRefuseActionBar extends StatelessWidget {
  const _ExchangeAcceptOrRefuseActionBar({
    required this.onExchangeAcceptPressed,
    required this.onExchangeRefusePressed,
  });

  final VoidCallback onExchangeAcceptPressed;
  final VoidCallback onExchangeRefusePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.greyLight),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ButtonRounded(
              onPressed: onExchangeAcceptPressed,
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: "Accepter",
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ButtonOutlinedRounded(
              onPressed: onExchangeRefusePressed,
              borderColor: AppColors.blueGreen,
              textColor: AppColors.blueGreen,
              padding: const EdgeInsets.symmetric(vertical: 14),
              text: "Refuser",
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTextInput extends StatefulWidget {
  const _ChatTextInput({
    required this.onSend,
  });

  final void Function(String text) onSend;

  @override
  State<_ChatTextInput> createState() => _ChatTextInputState();
}

class _ExchangeInfoBar extends StatelessWidget {
  final String text;
  final Color color;

  const _ExchangeInfoBar({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: color.withOpacity(.1),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
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
          border: Border(
            top: BorderSide(color: AppColors.greyLight),
          ),
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
