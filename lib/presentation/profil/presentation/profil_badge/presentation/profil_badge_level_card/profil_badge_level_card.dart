import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_badge/widget/profil_level_progress_indicator.dart';
import 'package:plant_match_v2/presentation/user_points/presentation/utils/user_points_utils.dart';

class ProfilBadgeLevelCard extends StatelessWidget {
  const ProfilBadgeLevelCard({
    super.key,
    required this.level,
    required this.points,
    required this.maxPoints,
  });

  final int level;
  final int points;
  final int maxPoints;

  IconData _getIconForLevel(int level) {
    return UserPointsUtils.getIconForLevel(level);
  }

  String _getLevelName(int level) {
    return UserPointsUtils.getLevelName(level);
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: AppColors.greenLight.withOpacity(0.3),
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
                    child: Text(
                      _getLevelName(level),
                      style: const TextStyle(
                        fontSize: AppTypo.textM,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blueGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ProfilLevelProgressIndicator(
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
