import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/account_settings_app_bar.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/account_settings_list.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/delete_account_button.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/delete_account_listener.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DeleteAccountListener(
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AccountSettingsAppBar(title: t.accountSettings.screen.title),
        body: const AccountSettingsList(),
        bottomNavigationBar: const SafeArea(child: DeleteAccountButton()),
      ),
    );
  }
}
