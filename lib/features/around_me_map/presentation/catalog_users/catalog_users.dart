import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widget/card_plant.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/detail_plant.dart';

class CatalogUsers extends StatelessWidget {
  const CatalogUsers({
    super.key,
    required this.catalogs,
  });

  final List<Catalog> catalogs;

  @override
  Widget build(BuildContext context) {
    final publishedCatalogs =
        catalogs.where((catalog) => catalog.isPublish == true).toList();
    return publishedCatalogs.isEmpty
        ? const Center(
            child: Text(
              "Aucun catalogue disponible",
              style: TextStyle(color: AppColors.greyDark),
            ),
          )
        : ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            itemCount: publishedCatalogs.length,
            itemBuilder: (context, index) {
              final catalog = publishedCatalogs[index];
              return CardPlant(
                imageUrl: catalog.images.first,
                name: catalog.name,
                description: catalog.description,
                environment: catalog.environment,
                offerType: catalog.offerType,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPlant(
                        catalog: catalog,
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 20),
          );
  }
}
