import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_fill_view.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_screen.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_card_item.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/core/widgets/dots_loader/dots_loader_page.dart';

import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';

class CatalogListTab extends StatelessWidget {
  const CatalogListTab({
    super.key,
    required this.status,
    required this.sortOption,
  });

  final CatalogStatus status;
  final CatalogSortOption sortOption;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        return switch (state) {
          CatalogInitial() || CatalogLoading() => const DotsLoaderPage(),
          CatalogError(:final failure) => Center(
              child: Text(
                failure.errorContent.message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          CatalogLoaded(:final catalogs) => _buildList(
              context,
              _sortCatalogs(
                catalogs.where((c) => c.status == status).toList(),
              ),
            ),
        };
      },
    );
  }

  List<Catalog> _sortCatalogs(List<Catalog> list) {
    switch (sortOption) {
      case CatalogSortOption.newest:
        return list..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case CatalogSortOption.nameAsc:
        return list
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      case CatalogSortOption.nameDesc:
        return list
          ..sort(
              (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    }
  }

  Widget _buildList(BuildContext context, List<Catalog> catalogs) =>
      RefreshScreen(
        onRefresh: () => context.read<AuthCubit>().userId.match(
              () => Future<void>.value(),
              context.read<CatalogCubit>().refresh,
            ),
        child: catalogs.isEmpty
            ? RefreshFillView(
                child: Center(
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
                ),
              )
            : Container(
                color: AppColors.greyUltraLight,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppSpacing.paddingHorizontal +
                      const EdgeInsets.only(top: 10, bottom: 100),
                  itemCount: catalogs.length,
                  itemBuilder: (context, index) =>
                      CatalogCardItem(catalog: catalogs[index]),
                ),
              ),
      );

  String _getEmptyMessage() => switch (status) {
        CatalogStatus.archived => t.catalog.empty.no_archived,
        CatalogStatus.draft => t.catalog.empty.no_draft,
        CatalogStatus.published => t.catalog.empty.no_published,
      };
}
