import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catolog/presentation/add_plant_wizard/add_plant_wizard_page.dart';
import 'package:plant_match_v2/features/catolog/presentation/catalog_card_item.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/features/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/features/catolog/widget/catalog_card_is_empty.dart';

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

class _CatalogScreenState extends State<CatalogScreen>
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
        image: const Image(
          image: AssetImage('assets/images/header_catalog.jpg'),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        styleIconButton: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: AppColors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddPlantWizardPage(
                catalog: widget.catalog,
              ),
            ),
          );

          if (result == true && context.mounted) {
            final userId = context.read<AuthCubit>().userId;
            if (userId != null) {
              context.read<CatalogCubit>().getCatalogsByUserId(userId);
            }
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        backgroundColor: AppColors.greenLight,
        child: const Icon(LucideIcons.plus, color: AppColors.blueGreen),
      ),
      body: widget.catalogs.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingHorizontal +
                      const EdgeInsets.only(top: 16),
                  child: const TitlePage(
                    title: 'Mes plantes',
                    subtitle: 'Mon catalogue de plantes à partager',
                  ),
                ),
                const SizedBox(height: 90),
                const Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: AppSpacing.paddingHorizontal,
                      child: CatalogCardIsEmpty(),
                    )),
                  ],
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: AppSpacing.paddingHorizontal,
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage(
                            'assets/images/empty_catalog_filter.png'),
                        height: 200,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Ton catalogue est vide. Ajoute ta première plante pour commencer.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingHorizontal +
                      const EdgeInsets.only(top: 16),
                  child: const TitlePage(
                    title: 'Mes plantes',
                    subtitle: 'Mon catalogue de plantes à partager',
                  ),
                ),
                Padding(
                  padding: AppSpacing.paddingHorizontal +
                      const EdgeInsets.only(top: 10),
                  child: TabBar.secondary(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text:
                            'Publié (${widget.catalogs.where((c) => c.status == CatalogStatus.published).length})',
                      ),
                      Tab(
                        text:
                            'Brouillon (${widget.catalogs.where((c) => c.status == CatalogStatus.draft).length})',
                      ),
                      Tab(
                        text:
                            'Archivé (${widget.catalogs.where((c) => c.status == CatalogStatus.archived).length})',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTabContent(CatalogStatus.published),
                      _buildTabContent(CatalogStatus.draft),
                      _buildTabContent(CatalogStatus.archived),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTabContent(CatalogStatus status) {
    return BlocBuilder<CatalogCubit, CatalogState>(
      builder: (context, state) {
        return switch (state) {
          CatalogInitial() || CatalogLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          CatalogError() => Center(
              child: Text(
                'Erreur de chargement du catalogue',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          CatalogLoaded() => _buildCatalogList(
              state.catalogs.where((c) => c.status == status).toList(),
              status,
            ),
        };
      },
    );
  }

  Widget _buildCatalogList(List<Catalog> catalogs, CatalogStatus status) {
    if (catalogs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(
            status == CatalogStatus.archived
                ? 'Aucune plante archivée'
                : status == CatalogStatus.draft
                    ? 'Aucun brouillon'
                    : 'Aucune plante publiée',
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
      child: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 100),
          child: ListView(
            children: catalogs
                .map((catalog) => CatalogCardItem(catalog: catalog))
                .toList(),
          ),
        ),
      ),
    );
  }
}
