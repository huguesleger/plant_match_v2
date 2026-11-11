import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class PasswordSectionLabel extends StatelessWidget {
  const PasswordSectionLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: InterTextStyle.inter(
            AppTypo.textS,
            fontWeight: FontWeight.w600,
            color: AppColors.greyDark,
          ),
        ),
      ),
    );
  }
}
