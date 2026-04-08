import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class ChatThemes {
  ChatThemes._();

  static final DefaultChatTheme light = DefaultChatTheme(
    primaryColor: AppColors.white,
    secondaryColor: AppColors.greenLight.withValues(alpha: 0.3),
    backgroundColor: AppColors.greyUltraLight,
    inputBackgroundColor: AppColors.white,
    inputBorderRadius: const BorderRadius.all(Radius.zero),
/*    inputMargin: EdgeInsets.all(20),
    inputPadding: EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    inputBorderRadius: BorderRadius.vertical(
        top: Radius.circular(40), bottom: Radius.circular(40)),*/
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
  );
}
