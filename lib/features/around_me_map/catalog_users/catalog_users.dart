import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/card/card_plant.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/presentation/detail_plant/detail_plant.dart';

class CatalogUsers extends StatelessWidget {
  const CatalogUsers({
    super.key,
    required this.catalogs,
  });

  final List<Catalog> catalogs;

  @override
  Widget build(BuildContext context) {
    final publishedCatalogs = catalogs
        .where((catalog) => catalog.status == CatalogStatus.published)
        .toList();
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
                catalog: catalog,
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
