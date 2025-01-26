import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class ProfilLevelProgressIndicator extends StatelessWidget {
  const ProfilLevelProgressIndicator({
    super.key,
    required this.currentPoints,
    required this.maxPoints,
    required this.level,
  });

  final int currentPoints;
  final int maxPoints;
  final int level;

  double calculateLevelProgression(int currentPoints, int maxPoints) {
    if (maxPoints == 0) {
      return 0.0;
    }
    return currentPoints / maxPoints;
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateLevelProgression(currentPoints, maxPoints);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: 'Niveau ',
                style: const TextStyle(
                  fontSize: AppTypo.textS,
                  color: AppColors.greenMedium,
                ),
                children: [
                  TextSpan(
                    text: '$level',
                    style: const TextStyle(
                      fontSize: AppTypo.textS,
                      color: AppColors.greenMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Niveau ',
                style: const TextStyle(
                  fontSize: AppTypo.textS,
                  color: AppColors.greenMedium,
                ),
                children: [
                  TextSpan(
                    text: '${level + 1}',
                    style: const TextStyle(
                      fontSize: AppTypo.textS,
                      color: AppColors.greenMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.blueGreen.withOpacity(0.3),
          color: AppColors.greenMedium,
          minHeight: 2,
        ),
      ],
    );
  }
}
