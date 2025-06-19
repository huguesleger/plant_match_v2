import 'package:flutter/material.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

class CatalogCardItem extends StatelessWidget {
  const CatalogCardItem({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catalog.name,
            ),
            const SizedBox(height: 8),
            Text(catalog.description),
          ],
        ),
      ),
    );
  }
}
