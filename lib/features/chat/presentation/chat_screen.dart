import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' hide ChatState;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:plant_match_v2/features/chat/presentation/state/chat_state.dart';
import 'package:plant_match_v2/features/chat/presentation/widget/chat_theme.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/message_format_date.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
  });

  final String chatId;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) async {
        if (state is ChatLoaded) {
          await context.read<ChatCubit>().markMessagesAsRead(
                chatId: chatId,
                currentUserId: currentUser.uid,
              );
        }
      },
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatInitial || state is ChatLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ChatError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          }

          final loaded = state as ChatLoaded;

          return Scaffold(
            appBar: AppBarTemplate(
              preferredHeight: 65,
              backgroundColor: AppColors.greenLight,
              surfaceTintColor: Colors.white,
              styleIconButton: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: AppColors.greyDark),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              titleWidget: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.greyLight,
                    backgroundImage: (otherUserAvatar.isNotEmpty &&
                            otherUserAvatar != 'null')
                        ? NetworkImage(otherUserAvatar)
                        : null,
                    child:
                        (otherUserAvatar.isEmpty || otherUserAvatar == 'null')
                            ? Text(
                                otherUserName[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    otherUserName,
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: AppTypo.textM,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Chillax',
                    ),
                  ),
                ],
              ),
            ),
            body: Chat(
              user: types.User(id: currentUser.uid),
              messages: loaded.messages,
              customDateHeaderText: (date) => messageFormatDate(context, date),
              onSendPressed: (types.PartialText message) {
                context.read<ChatCubit>().send(
                      chatId: chatId,
                      senderId: currentUser.uid,
                      receiverId: otherUserId,
                      text: message.text,
                    );
              },
              theme: ChatThemes.light,
              textMessageBuilder: (
                message, {
                required int messageWidth,
                required bool showName,
              }) {
                final isMe = message.author.id == currentUser.uid;
                final readAt = message.metadata?['readAt'];
                final isRead = readAt != null;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 30,
                        top: 8,
                        bottom: 4,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: messageWidth.toDouble(),
                      ),
                      child: Text(
                        message.text,
                        style: isMe
                            ? ChatThemes.light.sentMessageBodyTextStyle
                            : ChatThemes.light.receivedMessageBodyTextStyle,
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
                              color: isRead
                                  ? AppColors.greenMedium
                                  : AppColors.grey,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
