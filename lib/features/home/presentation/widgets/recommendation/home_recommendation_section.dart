import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/recommendation/home_recommendation_card.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/recommendation/home_recommendation_empty.dart';

class HomeRecommendationSection extends StatelessWidget {
  const HomeRecommendationSection({
    super.key,
    required this.plants,
    required this.onAdjustPressed,
  });

  final List<Catalog> plants;
  final VoidCallback onAdjustPressed;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.home.recommendation.title,
                style: const TextStyle(
                  fontSize: AppTypo.textM,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.sliders_horizontal,
                  color: AppColors.greyMedium,
                  size: 18,
                ),
                onPressed: onAdjustPressed,
                tooltip: t.home.recommendation.adjust_preferences,
              ),
            ],
          ),
          const SizedBox(height: 10),
          plants.isEmpty
              ? HomeRecommendationEmpty(onAdjustPressed: onAdjustPressed)
              : SizedBox(
                  height: 170,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: plants.length,
                    itemBuilder: (_, index) =>
                        HomeRecommendationCard(plant: plants[index]),
                  ),
                ),
        ],
      );
}
