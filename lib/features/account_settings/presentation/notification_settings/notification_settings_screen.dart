import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/account_settings_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AccountSettingsAppBar(
          title: t.accountSettings.items.notification_settings),
      // TODO: construire le contenu de la page.
      body: const SizedBox.shrink(),
    );
  }
}
