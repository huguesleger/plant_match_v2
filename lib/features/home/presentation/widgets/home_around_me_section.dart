import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_card_plant.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';

class HomeAroundMeSection extends StatelessWidget {
  const HomeAroundMeSection({
    super.key,
    required this.plants,
    required this.isGeolocated,
    required this.onSeeAllPressed,
  });

  final List<(Catalog, ProfilUser, double)> plants;
  final bool isGeolocated;
  final VoidCallback onSeeAllPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "Autour de toi",
                  style: TextStyle(
                      fontSize: AppTypo.textM,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.map_pin,
                    color: AppColors.greenMedium, size: 14),
                const SizedBox(width: 4),
                Text(
                  DistanceHelper.maxDistanceFormatted,
                  style: const TextStyle(
                      color: AppColors.greenMedium,
                      fontSize: AppTypo.textXs,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            TextButton(
              onPressed: onSeeAllPressed,
              child: const Row(
                children: [
                  Text("Voir sur la carte",
                      style: TextStyle(
                          color: AppColors.greyMedium,
                          fontSize: AppTypo.textXs)),
                  SizedBox(width: 2),
                  Icon(LucideIcons.chevron_right,
                      color: AppColors.greyMedium, size: 12),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: !isGeolocated
              ? _buildNoLocationState()
              : plants.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 10),
                      scrollDirection: Axis.horizontal,
                      itemCount: plants.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final (catalog, owner, distance) = plants[index];
                        return HomeCardPlant(
                          catalog: catalog,
                          owner: owner,
                          distance: distance,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailPlant(
                                      catalog: catalog,
                                      owner: owner,
                                    )),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() => const Center(
        child: Text("Aucune plante trouvée à proximité",
            style: TextStyle(
                color: AppColors.greyMedium, fontSize: AppTypo.textS)),
      );

  Widget _buildNoLocationState() => const Center(
        child: Text(
            "Activez la géolocalisation pour voir les plantes autour de vous",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.greyMedium, fontSize: AppTypo.textS)),
      );
}
