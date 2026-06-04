import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class CatalogDetailCharacteristics extends StatelessWidget {
  const CatalogDetailCharacteristics({super.key, required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll,
      decoration: BoxDecoration(
        color: AppColors.greenLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.greenDark.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CardDetailItem(
            icon: LucideIcons.sun,
            label: t.catalog.detail.lighting,
            value: catalog.lighting.lightingName,
          ),
          _CardDetailItem(
            icon: LucideIcons.droplet,
            label: t.catalog.detail.watering,
            value: catalog.watering.wateringName,
          ),
          _CardDetailItem(
            icon: LucideIcons.shovel,
            label: t.catalog.detail.maintenance,
            value: catalog.levelMaintenance.levelName,
          ),
        ],
      ),
    );
  }
}

class _CardDetailItem extends StatelessWidget {
  const _CardDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Container(
            color: AppColors.greenLight.withValues(alpha: 0.5),
            width: 35,
            height: 35,
            child: Icon(icon, color: AppColors.blueGreen, size: AppTypo.text),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: AppTypo.textXs,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: AppTypo.textXs,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
