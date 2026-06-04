import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class CatalogDetailBasicInfo extends StatelessWidget {
  const CatalogDetailBasicInfo({super.key, required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                catalog.name.toCapitalize(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    t.catalog.detail.plant_env(env: catalog.environment.envName),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 5),
                  _buildEnvironmentIcon(),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        BadgePill(
          text: Text(
            catalog.status.label,
            style: TextStyle(
              fontSize: 12,
              color: catalog.status.textColor,
            ),
          ),
          badgeColor: catalog.status.badgeColor,
        ),
      ],
    );
  }

  Widget _buildEnvironmentIcon() => ClipOval(
        child: Container(
          color: AppColors.greenLight.withValues(alpha: 0.5),
          width: 25,
          height: 25,
          child: Icon(
            catalog.environment == Environment.outdoor
                ? LucideIcons.trees
                : LucideIcons.house,
            color: AppColors.blueGreen,
            size: AppTypo.textS,
          ),
        ),
      );
}
