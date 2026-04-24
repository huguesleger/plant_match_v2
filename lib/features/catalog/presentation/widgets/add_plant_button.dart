import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_page_route.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';

class AddPlantButton extends StatelessWidget {
  const AddPlantButton({super.key, required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddPlantWizardPageRoute(catalog: catalog)),
        );

        if (result == true && context.mounted) {
          final userId = context.read<AuthCubit>().userId;
          if (userId != null) {
            context.read<CatalogCubit>().getCatalogsByUserId(userId);
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: AppColors.greenLight,
      child: const Icon(LucideIcons.plus, color: AppColors.blueGreen),
    );
  }
}
