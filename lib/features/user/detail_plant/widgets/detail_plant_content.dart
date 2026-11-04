import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/user/detail_plant/utils/detail_plant_loader.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/badge_family.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/detail_plant_title_row.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/detail_section_title.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/owner_profile_section.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_characteristic.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_environment.dart';
import 'package:plant_match_v2/features/user/detail_plant/widgets/plant_metrics_card.dart';

class DetailPlantContent extends StatelessWidget {
  const DetailPlantContent({super.key, required this.data});

  final DetailPlantData data;

  @override
  Widget build(BuildContext context) {
    final catalog = data.catalog;
    return Padding(
      padding: AppSpacing.paddingHorizontal,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BadgeFamily(family: catalog.family),
            DetailPlantTitleRow(catalog: catalog),
            PlantEnvironment(environment: catalog.environment),
            const SizedBox(height: 20),
            PlantMetricsCard(
              catalog: catalog,
              owner: data.owner,
              currentUser: data.currentUser,
            ),
            const SizedBox(height: 20),
            DetailSectionTitle(text: t.user.detail_plant.description_title),
            const SizedBox(height: 12),
            Text(
              catalog.description.toCapitalize(),
              style: const TextStyle(
                fontSize: AppTypo.text,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 24),
            OwnerProfileSection(owner: data.owner),
            const SizedBox(height: 24),
            DetailSectionTitle(text: t.user.detail_plant.key_info_title),
            const SizedBox(height: 24),
            PlantCharacteristic(
              lighting: catalog.lighting,
              watering: catalog.watering,
              levelMaintenance: catalog.levelMaintenance,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
