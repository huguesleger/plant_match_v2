import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/forgot_password_link.dart';
import 'package:plant_match_v2/features/account_settings/presentation/change_password/widgets/password_section_label.dart';
import 'package:plant_match_v2/features/auth/presentation/widgets/auth_password_field.dart';

class CurrentPasswordField extends StatelessWidget {
  const CurrentPasswordField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          PasswordSectionLabel(
            text: t.accountSettings.change_password.current_password.section,
          ),
          AuthPasswordField(
            controller: controller,
            labelText:
                Some(t.accountSettings.change_password.current_password.label),
            hintText:
                Some(t.accountSettings.change_password.current_password.hint),
          ),
          const ForgotPasswordLink(),
        ],
      ),
    );
  }
}
