import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_list_tab.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';

class CatalogTabs extends StatelessWidget {
  const CatalogTabs({
    super.key,
    required this.catalogs,
    required this.sortOption,
  });

  final List<Catalog> catalogs;
  final CatalogSortOption sortOption;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.paddingHorizontal
                  .add(const EdgeInsets.only(top: 10)),
              child: TabBar.secondary(
                tabs: _statuses
                    .map(
                      (status) => Tab(
                        text: _label(status, _byStatus(status).length),
                      ),
                    )
                    .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: _statuses
                    .map(
                      (status) => CatalogListTab(
                        status: status,
                        catalogs: _byStatus(status),
                        sortOption: sortOption,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );

  static const _statuses = [
    CatalogStatus.published,
    CatalogStatus.draft,
    CatalogStatus.archived,
  ];

  String _label(CatalogStatus status, int count) => switch (status) {
        CatalogStatus.published => t.catalog.tabs.published(count: count),
        CatalogStatus.draft => t.catalog.tabs.draft(count: count),
        CatalogStatus.archived => t.catalog.tabs.archived(count: count),
      };

  List<Catalog> _byStatus(CatalogStatus status) =>
      catalogs.where((c) => c.status == status).toList();
}
