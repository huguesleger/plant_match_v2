import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/dialog/app_dialog.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';

class DeleteAccountErrorDialog extends StatelessWidget {
  const DeleteAccountErrorDialog({super.key, required this.failure});

  final Failure failure;

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: t.accountSettings.delete_account.error_title,
      textAlign: TextAlign.left,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(failure.errorContent.message),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ButtonRounded(
                onPressed: Some(() => Navigator.of(context).pop()),
                text: t.auth.common.ok,
                bgColor: AppColors.greenLight,
                textColor: AppColors.blueGreen,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
