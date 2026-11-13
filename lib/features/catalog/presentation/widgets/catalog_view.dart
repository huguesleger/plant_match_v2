import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_fill_view.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_screen.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/show_catalog_sort_bottom_sheet.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/add_plant_button.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_empty_view.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_tabs.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class CatalogView extends StatelessWidget {
  const CatalogView({
    super.key,
    required this.catalogs,
    required this.catalog,
    required this.sortOption,
    this.isLoading = false,
  });

  final List<Catalog> catalogs;
  final Catalog catalog;
  final CatalogSortOption sortOption;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBarHeaderImage(
          image: Assets.res.images.headerCatalog.image(),
          onPressed: () => Navigator.pop(context),
          styleIconButton: Some(IconButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: AppColors.white,
          )),
          actions: Some([
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
                currentSortOption: sortOption,
                onSortApplied: (newSort) =>
                    context.read<CatalogCubit>().changeSortOption(newSort),
              ),
            ),
          ]),
        ),
        floatingActionButton: AppSkeletonizer(
          enabled: isLoading,
          child: AddPlantButton(catalog: catalog),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  AppSpacing.paddingHorizontal + const EdgeInsets.only(top: 16),
              child: TitlePage(
                title: t.catalog.screen.title,
                subtitle: Some(t.catalog.screen.subtitle),
              ),
            ),
            Expanded(
              child: catalogs.isEmpty
                  ? RefreshScreen(
                      onRefresh: () => context.read<AuthCubit>().userId.match(
                            () => Future<void>.value(),
                            context.read<CatalogCubit>().refresh,
                          ),
                      child: const RefreshFillView(child: CatalogEmptyView()),
                    )
                  : AppSkeletonizer(
                      enabled: isLoading,
                      child: CatalogTabs(
                        catalogs: catalogs,
                        sortOption: sortOption,
                      ),
                    ),
            ),
          ],
        ),
      );
}
