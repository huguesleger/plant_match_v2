import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

class MyBadges extends StatelessWidget {
  const MyBadges({
    super.key,
    required this.level,
    required this.levels,
  });

  final int level;
  final int levels;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
