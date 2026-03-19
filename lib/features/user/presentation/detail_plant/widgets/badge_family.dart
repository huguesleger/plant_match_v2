import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class BadgeFamily extends StatelessWidget {
  const BadgeFamily({super.key, required this.family});

  final List<Family> family;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingVertical,
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: family.map((f) {
          return BadgePill(
            text: Text(
              f.familyName,
              style: const TextStyle(fontSize: 12, color: AppColors.greenDark),
            ),
            badgeColor: AppColors.greenLight.withValues(alpha: 0.2),
          );
        }).toList(),
      ),
    );
  }
}
