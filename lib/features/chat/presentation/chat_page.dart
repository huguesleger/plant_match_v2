import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/chat/data/firebase_chat.dart';
import 'package:plant_match_v2/features/chat/domain/repository/chat_repository.dart';
import 'package:plant_match_v2/features/chat/presentation/chat_screen.dart';
import 'package:plant_match_v2/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:plant_match_v2/features/chat/presentation/state/chat_state.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
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

  final ChatRepository chatRepository = FirebaseChat();

  @override
  Widget build(BuildContext context) {
    final currentUser = fb_auth.FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Utilisateur non connecté')),
      );
    }

    return BlocProvider(
      create: (_) => ChatCubit(repository: chatRepository)
        ..subscribe(chatId)
        ..resetUnread(chatId, currentUser.uid)
        ..markMessagesAsRead(
          chatId: chatId,
          currentUserId: currentUser.uid,
        ),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          return switch (state) {
            ChatInitial() || ChatLoading() => const Scaffold(
                backgroundColor: AppColors.white,
                body: Center(child: CircularProgressIndicator()),
              ),
            ChatError() => ErrorPage(
                errorMessage: state.message,
                onRetry: () {
                  context.read<ChatCubit>().subscribe(chatId);
                },
              ),
            ChatLoaded() => ChatScreen(
                chatId: chatId,
                otherUserId: otherUserId,
                otherUserName: otherUserName,
                otherUserAvatar: otherUserAvatar,
              ),
          };
        },
      ),
    );
  }
}
