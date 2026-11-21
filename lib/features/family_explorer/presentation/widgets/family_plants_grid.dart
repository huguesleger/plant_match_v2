import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/family_explorer/domain/entities/family_plant.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_card_plant.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class FamilyPlantsGrid extends StatelessWidget {
  const FamilyPlantsGrid({super.key, required this.plants});

  final List<FamilyPlant> plants;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.familyExplorer.count(n: plants.length),
              style: const TextStyle(
                fontSize: AppTypo.textS,
                color: AppColors.greyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                spacing: 14,
                runSpacing: 16,
                children: plants
                    .map(
                      (plant) => HomeCardPlant(
                        catalog: plant.catalog,
                        owner: plant.owner,
                        distance: plant.distanceKm,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPlant(
                              catalog: plant.catalog,
                              owner: Some(plant.owner),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
