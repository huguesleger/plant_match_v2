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
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/chat/presentation/widget/chat_theme.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_format_date.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/widgets/badge_offer_type.dart';

class ChatPlantScreen extends StatelessWidget {
  const ChatPlantScreen({
    super.key,
    required this.chatId,
    required this.plantId,
    required this.plantName,
    required this.plantDescription,
    required this.plantImage,
    required this.plantExchangeType,
    required this.plantOwnerId,
    required this.plantOwnerName,
    required this.plantOwnerAvatar,
  });

  final String chatId;
  final String plantId;
  final String plantName;
  final String plantDescription;
  final String plantImage;
  final String plantExchangeType;

  final String plantOwnerId;
  final String plantOwnerName;
  final String plantOwnerAvatar;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    final OfferType offerType =
        OfferTypeExtension.fromString(plantExchangeType);

    final bool isPlantOwner = currentUser.uid == plantOwnerId;
    final bool showDonationAction =
        isPlantOwner && offerType == OfferType.donation;

    //final String avatar = plantOwnerAvatar ?? '';

    return BlocListener<ChatPlantCubit, ChatPlantState>(
      listener: (context, state) {
        if (state is ChatPlantLoaded) {
          context.read<ChatPlantCubit>().markMessagesAsRead(
                chatId: chatId,
                currentUserId: currentUser.uid,
              );
        }
      },
      child: BlocBuilder<ChatPlantCubit, ChatPlantState>(
        builder: (context, state) {
          if (state is ChatPlantInitial || state is ChatPlantLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ChatPlantError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          }

          final loaded = state as ChatPlantLoaded;

          return Scaffold(
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
                    backgroundColor: AppColors.greyLight,
                    backgroundImage: plantOwnerAvatar.isNotEmpty &&
                            plantOwnerAvatar != 'null'
                        ? NetworkImage(plantOwnerAvatar)
                        : null,
                    child:
                        plantOwnerAvatar.isEmpty || plantOwnerAvatar == 'null'
                            ? Text(
                                plantOwnerName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    plantOwnerName,
                    style: const TextStyle(
                      fontSize: AppTypo.textM,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyDark,
                      fontFamily: 'Chillax',
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                /// 🔝 Bandeau plante
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.greyLight),
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: plantImage.isNotEmpty
                            ? Image.network(
                                plantImage,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                color: AppColors.greyLight,
                                child: const Icon(
                                  Icons.local_florist,
                                  color: AppColors.greyDark,
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plantName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: InterTextStyle.inter(
                                AppTypo.text,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            BadgeOfferType(
                              offerType: offerType,
                              fontSize: AppTypo.textXxs,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// 💬 Chat
                Expanded(
                  child: Chat(
                    user: types.User(id: currentUser.uid),
                    messages: loaded.messages,
                    theme: ChatThemes.light,
                    emptyState: const Center(
                      child: Text(
                        'Aucun message pour le moment.\nDémarrez la conversation 🌱',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: AppTypo.text,
                        ),
                      ),
                    ),
                    customDateHeaderText: (date) =>
                        messageFormatDate(context, date),
                    customBottomWidget: Column(
                      children: [
                        if (showDonationAction)
                          _DonationActionBar(
                            onDonatePressed: () {
                              debugPrint('🌱 Proposer un don');
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
                    textMessageBuilder: (
                      message, {
                      required int messageWidth,
                      required bool showName,
                    }) {
                      final isMe = message.author.id == currentUser.uid;
                      final readAt = message.metadata?['readAt'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(8, 8, 30, 4),
                            constraints: BoxConstraints(
                              maxWidth: messageWidth.toDouble(),
                            ),
                            child: Text(
                              message.text,
                              style: isMe
                                  ? ChatThemes.light.sentMessageBodyTextStyle
                                  : ChatThemes
                                      .light.receivedMessageBodyTextStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  TimeOfDay.fromDateTime(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      message.createdAt ?? 0,
                                    ),
                                  ).format(context),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.greyDark,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                if (isMe)
                                  Icon(
                                    LucideIcons.check_check,
                                    size: 14,
                                    color: readAt != null
                                        ? AppColors.greenMedium
                                        : AppColors.grey,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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
          );
        },
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

class _ChatTextInput extends StatefulWidget {
  const _ChatTextInput({
    required this.onSend,
  });

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
