import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class DetailSectionTitle extends StatelessWidget {
  const DetailSectionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: InterTextStyle.inter(
          AppTypo.textL,
          fontWeight: FontWeight.bold,
          color: AppColors.greyDark,
        ),
      );
}
