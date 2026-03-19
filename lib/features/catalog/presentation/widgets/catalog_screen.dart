import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/presentation/add_plant_wizard/add_plant_wizard_page.dart';
import 'package:plant_match_v2/features/catalog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_empty_view.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_list_tab.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({
    super.key,
    required this.catalogs,
    required this.catalog,
  });

  final List<Catalog> catalogs;
  final Catalog catalog;

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
    return Scaffold(
      appBar: AppBarHeaderImage(
        image: const Image(image: AssetImage('assets/images/header_catalog.jpg')),
        onPressed: () => Navigator.pop(context),
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      floatingActionButton: _AddPlantFAB(catalog: widget.catalog),
      body: widget.catalogs.isEmpty
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
                      Tab(text: 'Publié (${_count(CatalogStatus.published)})'),
                      Tab(text: 'Brouillon (${_count(CatalogStatus.draft)})'),
                      Tab(text: 'Archivé (${_count(CatalogStatus.archived)})'),
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
    );
  }

  int _count(CatalogStatus status) => widget.catalogs.where((c) => c.status == status).length;
}

class _AddPlantFAB extends StatelessWidget {
  const _AddPlantFAB({required this.catalog});
  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddPlantWizardPageRoute(catalog: catalog)),
        );

        if (result == true && context.mounted) {
          final userId = context.read<AuthCubit>().userId;
          if (userId != null) {
            context.read<CatalogCubit>().getCatalogsByUserId(userId);
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      elevation: 0,
      backgroundColor: AppColors.greenLight,
      child: const Icon(LucideIcons.plus, color: AppColors.blueGreen),
    );
  }
}
