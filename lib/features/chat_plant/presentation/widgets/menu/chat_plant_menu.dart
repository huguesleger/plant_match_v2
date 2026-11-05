import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/cubit/chat_plant_cubit.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/state/chat_plant_state.dart';
import 'package:plant_match_v2/features/chat_plant/presentation/widgets/menu/chat_plant_menu_actions.dart';
import 'package:plant_match_v2/features/user/presentation/user_page_route.dart';

class ChatPlantMenu extends StatelessWidget {
  const ChatPlantMenu({
    super.key,
    required this.chatId,
    required this.otherUserId,
  });

  final String chatId;
  final String otherUserId;

  @override
  Widget build(BuildContext context) {
    final actions = ChatPlantMenuActions(
      context,
      chatId: chatId,
      otherUserId: otherUserId,
    );
    final blockedByMe = switch (context.watch<ChatPlantCubit>().state) {
      ChatPlantLoaded(:final blockStatus) =>
        blockStatus == BlockStatus.blockedByMe,
      ChatPlantInitial() ||
      ChatPlantLoading() ||
      ChatPlantBlocked() ||
      ChatPlantError() =>
        false,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: const BorderSide(color: AppColors.greyLight),
        ),
        icon: const Icon(LucideIcons.ellipsis_vertical),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        MenuItemButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => UserPageRoute(uid: otherUserId)),
          ),
          child: Text(t.chatPlant.menu.see_profile),
        ),
        MenuItemButton(
          onPressed: actions.onReport,
          child: Text(t.chatPlant.menu.report),
        ),
        MenuItemButton(
          onPressed: () =>
              blockedByMe ? actions.onUnblock() : actions.onBlock(),
          child: Text(
            blockedByMe ? t.chatPlant.menu.unblock : t.chatPlant.menu.block,
          ),
        ),
        MenuItemButton(
          onPressed: actions.onDeleteChat,
          child: Text(t.chatPlant.menu.clear_chat),
        ),
      ],
    );
  }
}
