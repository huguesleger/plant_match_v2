import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/message_cubit.dart';
import 'package:plant_match_v2/features/message/presentation/cubit/message_state.dart';
import 'package:plant_match_v2/features/message/presentation/message_empty.dart';
import 'package:plant_match_v2/features/message/presentation/message_item.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const AppBarTemplate(
        titleWidget: TitlePage(
          title: 'Mes messages',
          fontSize: AppTypo.textXl,
        ),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.black,
        leading: false,
        leadingWith: 16,
      ),
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
          MessagesLoaded(:final chats) => chats.isEmpty
              ? const MessageEmpty()
              : ListView.separated(
                  //padding: const EdgeInsets.only(top: 10),
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const Padding(
                    padding: AppSpacing.paddingHorizontal,
                    child: Divider(height: 1, color: AppColors.greyLight),
                  ),
                  itemBuilder: (context, index) =>
                      MessageItem(chat: chats[index]),
                ),
        },
      ),
    );
  }
}
