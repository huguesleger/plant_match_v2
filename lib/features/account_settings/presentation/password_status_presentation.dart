import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';

extension PasswordStatusPresentation on PasswordStatus {
  String get pageTitle => switch (this) {
        PasswordSet() => t.accountSettings.items.change_password,
        PasswordMissing() ||
        PasswordUnavailable() =>
          t.accountSettings.change_password.create.title,
      };

  String get loadingMessage => switch (this) {
        PasswordSet() => t.accountSettings.change_password.loading,
        PasswordMissing() ||
        PasswordUnavailable() =>
          t.accountSettings.change_password.create.loading,
      };

  String get successMessage => switch (this) {
        PasswordSet() => t.accountSettings.change_password.success,
        PasswordMissing() ||
        PasswordUnavailable() =>
          t.accountSettings.change_password.create.success,
      };
}
