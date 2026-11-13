import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class HomeSectionMessage extends StatelessWidget {
  const HomeSectionMessage({
    super.key,
    required this.message,
    this.textAlign = TextAlign.start,
  });

  final String message;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) => Text(
        message,
        textAlign: textAlign,
        style: const TextStyle(
          color: AppColors.greyMedium,
          fontSize: AppTypo.textS,
        ),
      );
}
