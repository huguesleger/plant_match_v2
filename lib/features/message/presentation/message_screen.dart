import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/message_cubit.dart';
import 'package:plant_match_v2/features/message/presentation/state/message_state.dart';
import 'package:plant_match_v2/features/message/presentation/widgets/messages_view.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('Messages')),
      body: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) => switch (state) {
          MessagesInitial() || MessagesLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          MessagesError(:final message) => ErrorPage(
              errorMessage: message,
              onRetry: () {
                if (currentUser != null) {
                  context.read<MessagesCubit>().load(currentUser.uid);
                }
              },
            ),
          MessagesLoaded(:final chats) => MessagesView(chats: chats),
        },
      ),
    );
  }
}
