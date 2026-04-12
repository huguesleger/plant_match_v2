import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

class LevelDetailIcon extends StatelessWidget {
  const LevelDetailIcon({super.key, required this.level});

  final int level;

  IconData _getIconForLevel(int level) => UserPointsUtils.getIconForLevel(level);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 53,
      height: 53,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppColors.greenDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        _getIconForLevel(level),
        color: AppColors.greyDark,
        size: 24,
      ),
    );
  }
}
