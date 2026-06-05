import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class HomeRecommendedBanner extends StatelessWidget {
  const HomeRecommendedBanner({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: AppColors.greenDark, shape: BoxShape.circle),
              child: const Icon(LucideIcons.sparkles,
                  color: AppColors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Trouve ta plante idéale",
                    style: TextStyle(
                        fontSize: AppTypo.text,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Réponds à quelques questions et nous te suggérons des plantes !",
                    style: TextStyle(
                        fontSize: AppTypo.textXs,
                        color: AppColors.greyDark.withValues(alpha: 0.8),
                        height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
