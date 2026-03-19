import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_card_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';

class CatalogListTab extends StatelessWidget {
  const CatalogListTab({super.key, required this.status});

  final CatalogStatus status;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        return switch (state) {
          CatalogInitial() || CatalogLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          CatalogError(:final message) => Center(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          CatalogLoaded(:final catalogs) => _buildList(
              catalogs.where((c) => c.status == status).toList(),
            ),
        };
      },
    );
  }

  Widget _buildList(List<Catalog> catalogs) {
    if (catalogs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(
            _getEmptyMessage(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.greyUltraLight,
      child: ListView.builder(
        padding: AppSpacing.paddingHorizontal + const EdgeInsets.only(top: 10, bottom: 100),
        itemCount: catalogs.length,
        itemBuilder: (context, index) => CatalogCardItem(catalog: catalogs[index]),
      ),
    );
  }

  String _getEmptyMessage() => switch (status) {
        CatalogStatus.archived => 'Aucune plante archivée',
        CatalogStatus.draft => 'Aucun brouillon',
        CatalogStatus.published => 'Aucune plante publiée',
      };
}
