import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/show_catalog_sort_bottom_sheet.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/add_plant_button.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_empty_view.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_list_tab.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CatalogLoadedView extends StatefulWidget {
  const CatalogLoadedView({
    super.key,
    required this.catalogs,
    required this.catalog,
    required this.sortOption,
  });

  final List<Catalog> catalogs;
  final Catalog catalog;
  final CatalogSortOption sortOption;

  @override
  State<CatalogLoadedView> createState() => _CatalogLoadedViewState();
}

class _CatalogLoadedViewState extends State<CatalogLoadedView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHeaderImage(
        image: Assets.res.images.headerCatalog.image(),
        onPressed: () => Navigator.pop(context),
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
        actions: [
          IconButton(
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: AppColors.white,
            ),
            icon: const Icon(
              LucideIcons.sliders_horizontal,
              color: AppColors.blueGreen,
              size: AppTypo.textM,
            ),
            onPressed: () => showCatalogSortBottomSheet(
              context: context,
              currentSortOption: widget.sortOption,
              onSortApplied: (newSort) =>
                  context.read<CatalogCubit>().changeSortOption(newSort),
            ),
          ),
        ],
      ),
      floatingActionButton: AddPlantButton(catalog: widget.catalog),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                AppSpacing.paddingHorizontal + const EdgeInsets.only(top: 16),
            child: TitlePage(
              title: t.catalog.screen.title,
              subtitle: t.catalog.screen.subtitle,
            ),
          ),
          Expanded(
            child: widget.catalogs.isEmpty
                ? const CatalogEmptyView()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppSpacing.paddingHorizontal
                            .add(const EdgeInsets.only(top: 10)),
                        child: TabBar.secondary(
                          controller: _tabController,
                          tabs: [
                            Tab(
                                text: t.catalog.tabs.published(
                                    count: _count(widget.catalogs,
                                        CatalogStatus.published))),
                            Tab(
                                text: t.catalog.tabs.draft(
                                    count: _count(
                                        widget.catalogs, CatalogStatus.draft))),
                            Tab(
                                text: t.catalog.tabs.archived(
                                    count: _count(widget.catalogs,
                                        CatalogStatus.archived))),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            CatalogListTab(
                              status: CatalogStatus.published,
                              sortOption: widget.sortOption,
                            ),
                            CatalogListTab(
                              status: CatalogStatus.draft,
                              sortOption: widget.sortOption,
                            ),
                            CatalogListTab(
                              status: CatalogStatus.archived,
                              sortOption: widget.sortOption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  int _count(List<Catalog> catalogs, CatalogStatus status) =>
      catalogs.where((c) => c.status == status).length;
}
