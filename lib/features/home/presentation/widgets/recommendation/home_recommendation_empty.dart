import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';

class HomeRecommendationEmpty extends StatelessWidget {
  const HomeRecommendationEmpty({super.key, required this.onAdjustPressed});

  final VoidCallback onAdjustPressed;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              t.home.recommendation.empty,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppTypo.textXs,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 12),
            ButtonOutlinedRounded.small(
              borderColor: AppColors.greenDark,
              textColor: AppColors.greenDark,
              text: t.home.recommendation.adjust_filters,
              onPressed: onAdjustPressed,
            ),
          ],
        ),
      );
}
