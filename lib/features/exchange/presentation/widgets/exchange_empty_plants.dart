import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_page_route.dart';
import 'package:plant_match_v2/features/exchange/presentation/cubit/exchange_proposal_cubit.dart';

class ExchangeEmptyPlants extends StatelessWidget {
  const ExchangeEmptyPlants({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.res.images.emptyCatalogFilter.image(height: 200),
              const SizedBox(height: 24),
              TitlePage(
                title: t.exchange.picker.no_plants,
                fontSize: AppTypo.textL,
                textAlign: const Some(TextAlign.center),
              ),
              const SizedBox(height: 12),
              Text(
                t.exchange.picker.no_plants_description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppTypo.textS,
                  color: AppColors.greyMedium,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ButtonRoundedWithIcon(
                  text: t.exchange.picker.add_plant,
                  onPressed: () => _openAddPlantWizard(context),
                  bgColor: AppColors.greenLight,
                  textColor: AppColors.blueGreen,
                  icon:
                      const Icon(LucideIcons.plus, color: AppColors.blueGreen),
                  iconAlignment: IconAlignment.start,
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _openAddPlantWizard(BuildContext context) {
    final proposalCubit = context.read<ExchangeProposalCubit>();
    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddPlantWizardPageRoute(catalog: Catalog.empty(userId)),
      ),
    ).then(
      (published) => published == true ? proposalCubit.load() : null,
    );
  }
}
