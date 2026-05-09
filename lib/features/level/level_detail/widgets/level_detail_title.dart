import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

class LevelDetailTitle extends StatelessWidget {
  const LevelDetailTitle({super.key, required this.level});

  final int level;

  String _getLevelName(int level) => UserPointsUtils.getLevelName(level);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitlePage(
          title: t.level.detail.level_title(level: level),
          fontSize: AppTypo.textXl,
        ),
        Text(
          _getLevelName(level),
          style: const TextStyle(
            fontSize: AppTypo.text,
            color: AppColors.greyMedium,
          ),
        ),
      ],
    );
  }
}
