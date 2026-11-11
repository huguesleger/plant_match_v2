import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class CreatePasswordIntro extends StatelessWidget {
  const CreatePasswordIntro({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Text(
        t.accountSettings.change_password.create.intro(email: email),
        style: InterTextStyle.inter(AppTypo.textS, color: AppColors.greyDark),
      ),
    );
  }
}
