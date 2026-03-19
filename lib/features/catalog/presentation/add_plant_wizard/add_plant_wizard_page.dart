import 'package:flutter/material.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_screen.dart';

class AddPlantWizardPageRoute extends StatelessWidget {
  const AddPlantWizardPageRoute({super.key, required this.catalog});

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return AddPlantWizardScreen(catalog: catalog);
  }
}
