import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/level/widget/level_progress_indicator.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

class LevelPointsCard extends StatelessWidget {
  const LevelPointsCard({
    super.key,
    required this.level,
    required this.points,
    required this.maxPoints,
  });

  final int level;
  final int points;
  final int maxPoints;

  IconData _getIconForLevel(int level) => UserPointsUtils.getIconForLevel(level);

  String _getLevelName(int level) => UserPointsUtils.getLevelName(level);

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.greenLight.withValues(alpha: 0.3),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 53,
                    height: 53,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: AppColors.greenMedium,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      _getIconForLevel(level),
                      color: AppColors.greenLight,
                      size: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(_getLevelName(level),
                        style: InterTextStyle.inter(
                          AppTypo.textM,
                          color: AppColors.blueGreen,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LevelProgressIndicator(
                currentPoints: points,
                maxPoints: maxPoints,
                level: level,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
