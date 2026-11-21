import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_page_route.dart';
import 'package:plant_match_v2/features/catalog/presentation/util/family_image.dart';

class FamilyExplorerEmpty extends StatelessWidget {
  const FamilyExplorerEmpty({super.key, required this.family});

  final Family family;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: family.image.image(
                  width: 140,
                  height: 175,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                t.familyExplorer.empty_title(family: family.familyName),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppTypo.text,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.familyExplorer.empty_description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppTypo.textS,
                  color: AppColors.greyDark,
                ),
              ),
              const SizedBox(height: 32),
              ButtonRounded(
                text: t.familyExplorer.publish,
                onPressed: Some(() => _openWizard(context)),
                bgColor: AppColors.blueGreen,
                textColor: AppColors.white,
              ),
            ],
          ),
        ),
      );

  Future<bool?> _openWizard(BuildContext context) => Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => AddPlantWizardPageRoute(
            catalog: Catalog.empty(
              context.read<AuthCubit>().userId.getOrElse(() => ''),
            ),
          ),
        ),
      );
}
