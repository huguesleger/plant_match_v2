import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_points_card.dart';

class MyLevel extends StatelessWidget {
  const MyLevel({
    super.key,
    required this.currentPoints,
    required this.level,
    required this.maxPoints,
  });

  final int currentPoints;
  final int level;
  final int maxPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyUltraLight,
      width: double.infinity,
      child: Padding(
        padding: AppSpacing.paddingHorizontal +
            const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            TitlePage(
              title: t.level.screen.my_level,
              fontSize: AppTypo.textXl,
            ),
            const SizedBox(height: 20),
            LevelPointsCard(
              level: level,
              points: currentPoints,
              maxPoints: maxPoints,
            ),
          ],
        ),
      ),
    );
  }
}
