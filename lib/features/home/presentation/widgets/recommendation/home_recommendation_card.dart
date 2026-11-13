import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/network_image/app_network_image.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeRecommendationCard extends StatelessWidget {
  const HomeRecommendationCard({super.key, required this.plant});

  final Catalog plant;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailPlant(catalog: plant)),
          ),
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
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: SizedBox(
                      width: double.infinity,
                      child: Skeleton.leaf(
                        child: plant.images.firstOption
                            .filter((url) => url.startsWith('http'))
                            .match(
                              () => Assets.res.images.emptyPicture
                                  .image(fit: BoxFit.cover),
                              (url) => AppNetworkImage(url: url),
                            ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
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
                          fontSize: AppTypo.textXxs,
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
