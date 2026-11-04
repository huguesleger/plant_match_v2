import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class NoPlantsBanner extends StatelessWidget {
  const NoPlantsBanner({super.key, required this.isRadiusLimited});

  final bool isRadiusLimited;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.greenLight.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greenDark.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.aroundMeMap.map.empty_title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.blueGreen,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              isRadiusLimited
                  ? t.aroundMeMap.map.empty_widen
                  : t.aroundMeMap.map.empty_first,
              style: const TextStyle(color: AppColors.greyDark, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
