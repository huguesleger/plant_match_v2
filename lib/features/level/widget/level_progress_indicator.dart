import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class LevelProgressIndicator extends StatelessWidget {
  const LevelProgressIndicator({
    super.key,
    required this.currentPoints,
    required this.maxPoints,
    required this.level,
  });

  final int currentPoints;
  final int maxPoints;
  final int level;

  double calculateLevelProgression(int currentPoints, int maxPoints) =>
      maxPoints == 0 ? 0.0 : currentPoints / maxPoints;

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
                    style: InterTextStyle.inter(
                      AppTypo.textS,
                      color: AppColors.greenMedium,
                      fontWeight: FontWeight.w700,
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
                    style: InterTextStyle.inter(
                      AppTypo.textS,
                      color: AppColors.greenMedium,
                      fontWeight: FontWeight.w700,
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
          backgroundColor: AppColors.blueGreen.withValues(alpha: 0.3),
          color: AppColors.greenMedium,
          minHeight: 2,
        ),
      ],
    );
  }
}
