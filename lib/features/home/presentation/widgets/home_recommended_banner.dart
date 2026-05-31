import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';

class HomeRecommendedBanner extends StatelessWidget {
  const HomeRecommendedBanner({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(LucideIcons.sprout, color: AppColors.greenDark, size: 20),
                SizedBox(width: 6),
                Text(
                  "Recommandé pour toi",
                  style: TextStyle(fontSize: AppTypo.textM, fontWeight: FontWeight.bold, color: AppColors.black),
                ),
              ],
            ),
            TextButton(
              onPressed: onPressed,
              child: const Row(
                children: [
                  Text("Voir tout", style: TextStyle(color: AppColors.greyMedium, fontSize: AppTypo.textXs)),
                  SizedBox(width: 2),
                  Icon(LucideIcons.chevron_right, color: AppColors.greyMedium, size: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.green.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: AppColors.greenDark, shape: BoxShape.circle),
                  child: const Icon(LucideIcons.sparkles, color: AppColors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Trouve ta plante idéale",
                        style: TextStyle(fontSize: AppTypo.text, fontWeight: FontWeight.bold, color: AppColors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Réponds à quelques questions et nous te suggérons des plantes !",
                        style: TextStyle(fontSize: AppTypo.textXs, color: AppColors.greyDark.withValues(alpha: 0.8), height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Assets.res.images.onboarding.onboardingAdvice.image(
                      width: 65,
                      height: 65,
                      fit: BoxFit.contain,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.greenDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.arrow_right, color: AppColors.white, size: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
