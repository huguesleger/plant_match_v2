import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_bar.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/cubit/family_explorer_cubit.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/cubit/family_explorer_state.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/widgets/family_explorer_content.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class FamilyExplorerScreen extends StatelessWidget {
  const FamilyExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FamilyExplorerCubit, FamilyExplorerState>(
        builder: (context, state) => Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBarTemplate(
            title: Some(state.family.familyName),
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            shadowColor: const Some(AppColors.black),
            styleIconButton: Some(
              IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: const BorderSide(color: AppColors.greyLight),
              ),
            ),
            onPressed: Some(() => Navigator.pop(context)),
          ),
          body: Column(
            children: [
              FilterBar<CatalogFilter>(
                filters: CatalogFilter.values,
                selected: state.filter,
                onChanged: context.read<FamilyExplorerCubit>().selectFilter,
                labelBuilder: (filter) => filter.label,
                iconBuilder: (filter) => filter.icon,
              ),
              Expanded(
                child: FamilyExplorerContent(
                  family: state.family,
                  filter: state.filter,
                ),
              ),
            ],
          ),
        ),
      );
}
