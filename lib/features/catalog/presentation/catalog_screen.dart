import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_empty_view.dart';
import 'package:plant_match_v2/core/widgets/error/error_page.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_list_tab.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/add_plant_button.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with SingleTickerProviderStateMixin {
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
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) => switch (state) {
        CatalogInitial() || CatalogLoading() => const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        CatalogError(:final message) => Scaffold(
            body: ErrorPage(
              errorMessage: message,
              onRetry: () {
                final userId = context.read<AuthCubit>().userId;
                if (userId != null) {
                  context.read<CatalogCubit>().getCatalogsByUserId(userId);
                }
              },
            ),
          ),
        CatalogLoaded(:final catalogs, :final catalog) => Scaffold(
            appBar: AppBarHeaderImage(
              image: const Image(image: AssetImage('assets/images/header_catalog.jpg')),
              onPressed: () => Navigator.pop(context),
              styleIconButton: IconButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: AppColors.white,
              ),
            ),
            floatingActionButton: AddPlantButton(catalog: catalog),
            body: catalogs.isEmpty
                ? const CatalogEmptyView()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppSpacing.paddingHorizontal + const EdgeInsets.only(top: 16),
                        child: const TitlePage(
                          title: 'Mes plantes',
                          subtitle: 'Mon catalogue de plantes à partager',
                        ),
                      ),
                      Padding(
                        padding: AppSpacing.paddingHorizontal.add(const EdgeInsets.only(top: 10)),
                        child: TabBar.secondary(
                          controller: _tabController,
                          tabs: [
                            Tab(text: 'Publié (${_count(catalogs, CatalogStatus.published)})'),
                            Tab(text: 'Brouillon (${_count(catalogs, CatalogStatus.draft)})'),
                            Tab(text: 'Archivé (${_count(catalogs, CatalogStatus.archived)})'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: const [
                            CatalogListTab(status: CatalogStatus.published),
                            CatalogListTab(status: CatalogStatus.draft),
                            CatalogListTab(status: CatalogStatus.archived),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
      },
    );
  }

  int _count(List<Catalog> catalogs, CatalogStatus status) => catalogs.where((c) => c.status == status).length;
}
