import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/edit_catalog_screen.dart';

class EditCatalogPageRouteRoute extends StatelessWidget {
  const EditCatalogPageRouteRoute({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return EditCatalogScreen(catalog: catalog);
  }
}
