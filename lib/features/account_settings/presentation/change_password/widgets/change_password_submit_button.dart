import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';

class ChangePasswordSubmitButton extends StatelessWidget {
  const ChangePasswordSubmitButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: Text(t.accountSettings.change_password.submit),
      ),
    );
  }
}
