import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class ExchangeSectionTitle extends StatelessWidget {
  const ExchangeSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: InterTextStyle.inter(
          AppTypo.textM,
          fontWeight: FontWeight.w700,
          color: AppColors.greyDark,
        ),
      );
}
