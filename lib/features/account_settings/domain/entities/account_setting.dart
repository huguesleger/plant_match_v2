import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';

sealed class AccountSetting {
  const AccountSetting();

  static List<AccountSetting> valuesFor(PasswordStatus passwordStatus) => [
        ChangePassword(passwordStatus),
        const Notifications(),
        const NotificationSettings(),
        const LocationAccess(),
      ];
}

sealed class NavigableAccountSetting extends AccountSetting {
  const NavigableAccountSetting();
}

class ChangePassword extends NavigableAccountSetting {
  const ChangePassword(this.passwordStatus);

  final PasswordStatus passwordStatus;
}

class Notifications extends AccountSetting {
  const Notifications();
}

class NotificationSettings extends NavigableAccountSetting {
  const NotificationSettings();
}

class LocationAccess extends NavigableAccountSetting {
  const LocationAccess();
}
