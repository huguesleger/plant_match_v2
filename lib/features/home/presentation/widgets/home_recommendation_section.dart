import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class HomeRecommendationSection extends StatelessWidget {
  const HomeRecommendationSection({
    super.key,
    required this.plants,
    required this.onAdjustPressed,
  });

  final List<Catalog> plants;
  final VoidCallback onAdjustPressed;

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
                Text(
                  "Tes suggestions personnalisées",
                  style: TextStyle(
                    fontSize: AppTypo.textM,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(LucideIcons.sliders_horizontal,
                  color: AppColors.greyMedium, size: 18),
              onPressed: onAdjustPressed,
              tooltip: "Ajuster mes préférences",
            ),
          ],
        ),
        const SizedBox(height: 10),
        plants.isEmpty
            ? _buildEmptyState()
            : SizedBox(
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return _HorizontalPlantCard(plant: plants[index]);
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Aucune plante ne correspond à tes préférences actuelles.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppTypo.textXs,
              color: AppColors.greyDark,
            ),
          ),
          const SizedBox(height: 12),
          ButtonOutlinedRounded.small(
            borderColor: AppColors.greenDark,
            textColor: AppColors.greenDark,
            text: "Ajuster les filtres",
            onPressed: onAdjustPressed,
          ),
        ],
      ),
    );
  }
}

class _HorizontalPlantCard extends StatelessWidget {
  const _HorizontalPlantCard({required this.plant});

  final Catalog plant;

  @override
  Widget build(BuildContext context) {
    final imageOpt = Option.fromNullable(
      plant.images.isNotEmpty ? plant.images.first : null,
    ).filter((url) => url.startsWith('http'));

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPlant(catalog: plant),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 130,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.greyUltraLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: imageOpt.match(
                      () => Assets.res.images.emptyPicture.image(
                        fit: BoxFit.cover,
                      ),
                      (url) => Image.network(
                        url,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.name.toCapitalize(),
                      style: const TextStyle(
                        fontSize: AppTypo.textXs,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plant.environment.envName,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.greenDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
