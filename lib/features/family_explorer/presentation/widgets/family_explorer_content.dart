import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/family_explorer/domain/entities/family_plant.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/widgets/family_explorer_empty.dart';
import 'package:plant_match_v2/features/family_explorer/presentation/widgets/family_plants_grid.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class FamilyExplorerContent extends StatelessWidget {
  const FamilyExplorerContent({
    super.key,
    required this.family,
    required this.filter,
  });

  final Family family;
  final CatalogFilter filter;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AroundMeCubit, AroundMeState>(
        builder: (context, state) => switch (state) {
          AroundMeInitial() || AroundMeLoading() => AppSkeletonizer(
              enabled: true,
              child: FamilyPlantsGrid(
                plants: List.generate(4, (_) => FamilyPlant.boneMock()),
              ),
            ),
          AroundMeError(:final failure) => ErrorPage(
              failure: failure,
              onRetry: () => context.read<AroundMeCubit>().getAllUserProfiles(
                    context.read<AuthCubit>().userId.getOrElse(() => ''),
                  ),
            ),
          AroundMeLoaded(
            :final currentUser,
            :final users,
            :final userCatalogs,
          ) =>
            _loaded(
              FamilyPlant.from(
                currentUser: currentUser,
                users: users,
                userCatalogs: userCatalogs,
                family: family,
              ),
            ),
        },
      );

  Widget _loaded(List<FamilyPlant> plants) {
    final filtered =
        plants.where((plant) => filter.accepts(plant.catalog)).toList();
    return plants.isEmpty
        ? FamilyExplorerEmpty(family: family)
        : filtered.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    t.familyExplorer.filter_empty,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : FamilyPlantsGrid(plants: filtered);
  }
}
