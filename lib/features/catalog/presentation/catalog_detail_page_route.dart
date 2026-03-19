import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_detail_screen.dart';

class CatalogDetailPageRoute extends StatelessWidget {
  const CatalogDetailPageRoute({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return CatalogDetailScreen(catalog: catalog);
  }
}
