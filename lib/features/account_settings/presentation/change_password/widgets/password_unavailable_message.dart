import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class PasswordUnavailableMessage extends StatelessWidget {
  const PasswordUnavailableMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(LucideIcons.info, color: AppColors.blueGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            t.accountSettings.change_password.unavailable,
            style: InterTextStyle.inter(
              AppTypo.textS,
              color: AppColors.greyDark,
            ),
          ),
        ),
      ],
    );
  }
}
