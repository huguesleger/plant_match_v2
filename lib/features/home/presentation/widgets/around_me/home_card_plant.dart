import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_card_plant_info.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_card_plant_visual.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HomeCardPlant extends StatelessWidget {
  const HomeCardPlant({
    super.key,
    required this.catalog,
    required this.owner,
    required this.onPressed,
    this.distance = const None(),
  });

  final Catalog catalog;
  final ProfilUser owner;
  final VoidCallback onPressed;
  final Option<double> distance;

  static const double _width = 155;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 6,
        shadowColor: AppColors.black.withValues(alpha: 0.2),
        clipBehavior: Clip.antiAlias,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.greyUltraLight, width: 1),
        ),
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: _width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeCardPlantVisual(
                  catalog: catalog,
                  owner: owner,
                  width: _width,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 12,
                    right: 12,
                    bottom: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        catalog.name.toCapitalize(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: AppTypo.textS,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      HomeCardPlantInfo(owner: owner, distance: distance),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
