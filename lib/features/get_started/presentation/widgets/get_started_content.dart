import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class GetStartedContent extends StatelessWidget {
  const GetStartedContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TitlePage(
          title: t.getStarted.title,
          fontSize: AppTypo.textXxl,
          fontWeight: FontWeight.bold,
          color: AppColors.greenLight,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            t.getStarted.subtitle,
            style: const TextStyle(
              fontSize: AppTypo.textS,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
