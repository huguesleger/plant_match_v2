import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';

class HomeAroundMeHeader extends StatelessWidget {
  const HomeAroundMeHeader({super.key, required this.onSeeAllPressed});

  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                t.home.around_me.title,
                style: const TextStyle(
                  fontSize: AppTypo.textM,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                LucideIcons.map_pin,
                color: AppColors.greenMedium,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                DistanceHelper.maxDistanceFormatted,
                style: const TextStyle(
                  color: AppColors.greenMedium,
                  fontSize: AppTypo.textXs,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: onSeeAllPressed,
            iconAlignment: IconAlignment.end,
            label: Text(
              t.home.around_me.see_on_map,
              style: const TextStyle(
                color: AppColors.greyMedium,
                fontSize: AppTypo.textXs,
              ),
            ),
            icon: const Icon(
              LucideIcons.chevron_right,
              color: AppColors.greyMedium,
              size: 12,
            ),
          ),
        ],
      );
}
