import 'package:flutter/widgets.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/account_settings/domain/entities/account_setting.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/change_password_page_route.dart';
import 'package:plant_match_v2/features/account_settings/presentation/location_access/location_access_page_route.dart';
import 'package:plant_match_v2/features/account_settings/presentation/notification_settings/notification_settings_page_route.dart';
import 'package:plant_match_v2/features/account_settings/presentation/notifications/notifications_page_route.dart';
import 'package:plant_match_v2/features/account_settings/presentation/password_status_presentation.dart';

extension AccountSettingPresentation on AccountSetting {
  String get title => switch (this) {
        ChangePassword(:final passwordStatus) => passwordStatus.pageTitle,
        Notifications() => t.accountSettings.items.notifications,
        NotificationSettings() => t.accountSettings.items.notification_settings,
        LocationAccess() => t.accountSettings.items.location_access,
      };

  IconData get icon => switch (this) {
        ChangePassword() => LucideIcons.lock,
        Notifications() => LucideIcons.bell,
        NotificationSettings() => LucideIcons.sliders_horizontal,
        LocationAccess() => LucideIcons.map_pin,
      };

  Widget get page => switch (this) {
        ChangePassword(:final passwordStatus) =>
          ChangePasswordPageRoute(passwordStatus: passwordStatus),
        Notifications() => const NotificationsPageRoute(),
        NotificationSettings() => const NotificationSettingsPageRoute(),
        LocationAccess() => const LocationAccessPageRoute(),
      };
}
