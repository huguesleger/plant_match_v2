import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_card.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_points_card.dart';
import 'package:plant_match_v2/features/level/widget/level_card/level_card_header.dart';
import 'package:plant_match_v2/features/level/widget/level_items.dart';

class LevelView extends StatelessWidget {
  const LevelView({super.key, required this.userPoints});

  final UserPoints userPoints;

  @override
  Widget build(BuildContext context) {
    final level = userPoints.level;
    final currentPoints = userPoints.currentPoints;
    final maxPoints = UserPointsUtils.getMaxPointsForLevel(level);
    final levels = UserPointsUtils.levelData.length;

    return Stack(
      children: [
        Container(
          height: 60,
          color: AppColors.greenLight,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  AppSpacing.paddingHorizontal + const EdgeInsets.only(top: 30),
              child: LevelCardHeader(
                currentPoints: currentPoints,
                level: level,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppSpacing.paddingHorizontal +
                          const EdgeInsets.symmetric(vertical: 30),
                      child: const LevelCard(),
                    ),
                    Container(
                      color: AppColors.greyUltraLight,
                      width: double.infinity,
                      child: Padding(
                        padding: AppSpacing.paddingHorizontal +
                            const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const TitlePage(
                              title: 'Mon niveau',
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
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: AppSpacing.paddingHorizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TitlePage(
                            title: 'Mes badges',
                            fontSize: AppTypo.textXl,
                          ),
                          BadgePill(
                            text: Text(
                              '$level/$levels',
                              style: const TextStyle(
                                fontSize: AppTypo.textXs,
                                color: AppColors.white,
                              ),
                            ),
                            badgeColor: AppColors.greenMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 150,
                      child: Padding(
                        padding: AppSpacing.paddingHorizontal,
                        child: LevelItems(currentLevel: level),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
