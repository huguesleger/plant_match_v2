import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
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
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_page.dart';
import 'package:plant_match_v2/core/widgets/app_loader/app_loader_gate.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarTemplate(
        titleWidget: Some(TitlePage(
          title: t.message.screen.title,
          fontSize: AppTypo.textXl,
        )),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: const Some(AppColors.black),
        leading: false,
        leadingWith: 16,
      ),
      body: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) => AppLoaderGate(
          isLoading: state is MessagesInitial || state is MessagesLoading,
          child: switch (state) {
            MessagesInitial() || MessagesLoading() => const AppLoaderPage(),
            MessagesError(:final failure) => ErrorPage(
                failure: failure,
                onRetry: () {
                  userId.map((id) => context.read<MessagesCubit>().load(id));
                },
              ),
            MessagesLoaded(:final chats) => chats.isEmpty
                ? const MessageEmpty()
                : ListView.separated(
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
      ),
    );
  }
}
