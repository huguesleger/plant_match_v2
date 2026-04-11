import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_bar.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/list_plants/catalog_list.dart';

class UserCatalogFilterSection extends StatelessWidget {
  const UserCatalogFilterSection({
    super.key,
    required this.selectedFilter,
    required this.filteredCatalogs,
  });

  final CatalogFilter selectedFilter;
  final dynamic filteredCatalogs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FilterBar<CatalogFilter>(
          filters: CatalogFilter.values,
          selected: selectedFilter,
          onChanged: (filter) => context.read<UserCubit>().updateFilter(filter),
          labelBuilder: (f) => f.label,
          iconBuilder: (f) => f.icon,
        ),
        const SizedBox(height: 16),
        CatalogList(catalogs: filteredCatalogs),
        const SizedBox(height: 30),
      ],
    );
  }
}
