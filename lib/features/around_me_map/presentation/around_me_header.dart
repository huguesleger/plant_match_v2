import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class AroundMeHeader extends StatelessWidget {
  const AroundMeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.paddingHorizontal,
          child: TitlePage(
            title: t.aroundMeMap.header.title,
            fontSize: AppTypo.textXl,
          ),
        ),
        Padding(
          padding: AppSpacing.paddingHorizontal +
              const EdgeInsets.symmetric(vertical: 10),
          child: Text(t.aroundMeMap.header.subtitle),
        ),
      ],
    );
  }
}