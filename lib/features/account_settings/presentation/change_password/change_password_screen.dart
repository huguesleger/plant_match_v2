import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/change_password_form.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/change_password_listener.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/create_password_intro.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/password_unavailable_message.dart';
import 'package:plant_match_v2/features/account_settings/presentation/password_status_presentation.dart';
import 'package:plant_match_v2/features/account_settings/presentation/widgets/account_settings_app_bar.dart';
import 'package:plant_match_v2/features/auth/domain/entities/password_status.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key, required this.passwordStatus});

  final PasswordStatus passwordStatus;

  @override
  Widget build(BuildContext context) {
    return ChangePasswordListener(
      loadingMessage: passwordStatus.loadingMessage,
      successMessage: passwordStatus.successMessage,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AccountSettingsAppBar(title: passwordStatus.pageTitle),
        body: SingleChildScrollView(
          padding: AppSpacing.paddingAll + const EdgeInsets.only(top: 32),
          child: switch (passwordStatus) {
            PasswordSet() =>
              const ChangePasswordForm(withCurrentPassword: true),
            PasswordMissing(:final email) => Column(
                children: [
                  CreatePasswordIntro(email: email),
                  const ChangePasswordForm(withCurrentPassword: false),
                ],
              ),
            PasswordUnavailable() => const PasswordUnavailableMessage(),
          },
        ),
      ),
    );
  }
}
