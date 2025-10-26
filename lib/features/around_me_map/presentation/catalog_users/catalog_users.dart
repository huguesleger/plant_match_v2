import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widget/card_plant.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class CatalogUsers extends StatelessWidget {
  const CatalogUsers({
    super.key,
    required this.catalogs,
  });

  final List<Catalog> catalogs;

  @override
  Widget build(BuildContext context) {
    return catalogs.isEmpty
        ? const Center(
            child: Text(
              "Aucun catalogue disponible",
              style: TextStyle(color: AppColors.greyDark),
            ),
          )
        : Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: catalogs.length,
              itemBuilder: (context, index) {
                final catalog = catalogs[index];
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: CardPlant(
                    imageUrl: catalog.images.first,
                    name: catalog.name,
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 20),
            ),
          );
  }
}
