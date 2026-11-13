import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/account_settings/domain/entities/account_setting.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/account_setting_navigation_tile.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/notifications_switch_tile.dart';

class AccountSettingTile extends StatelessWidget {
  const AccountSettingTile({super.key, required this.setting});

  final AccountSetting setting;

  @override
  Widget build(BuildContext context) => switch (setting) {
        final Notifications notifications =>
          NotificationsSwitchTile(setting: notifications),
        final NavigableAccountSetting navigable =>
          AccountSettingNavigationTile(setting: navigable),
      };
}
