import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class ChatThemes {
  ChatThemes._();

  static final DefaultChatTheme light = DefaultChatTheme(
    primaryColor: AppColors.greenMedium.withValues(alpha: 0.2),
    secondaryColor: AppColors.white,
    backgroundColor: AppColors.greenDark.withValues(alpha: 0.2),
    inputBackgroundColor: AppColors.white,
    inputBorderRadius: const BorderRadius.all(Radius.zero),
    inputTextColor: Colors.black,
    messageBorderRadius: 10,
    sentMessageBodyTextStyle: const TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w500,
      fontSize: 15,
    ),
    receivedMessageBodyTextStyle: const TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w500,
      fontSize: 15,
    ),
    sendButtonIcon: Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.blueGreen,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        LucideIcons.send_horizontal,
        color: AppColors.greenLight,
      ),
    ),
    deliveredIcon: const SizedBox.shrink(),
    seenIcon: const SizedBox.shrink(),
    sendingIcon: const SizedBox.shrink(),
    errorIcon: const SizedBox.shrink(),
  );
}
