import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_image.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/add_plant_wizard/add_plant_wizard_page.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/catalog_card_item.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_cubit.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/cubit/catalog_state.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/util/environment_name.dart';
import 'package:plant_match_v2/presentation/catolog/presentation/util/family_name.dart';
import 'package:plant_match_v2/presentation/catolog/widget/catalog_card_is_empty.dart';

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

class _CatalogScreenState extends State<CatalogScreen> {
  Object? _selectedFilter;

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
          ? const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: TitlePage(
                    title: 'Mes plantes',
                    subtitle: 'Mon catalogue de plantes à partager',
                  ),
                ),
                SizedBox(height: 90),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: CatalogCardIsEmpty(),
                    )),
                  ],
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: TitlePage(
                    title: 'Mes plantes',
                    subtitle: 'Mon catalogue de plantes à partager',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  child: buildFamilyFilterTabs(),
                ),
                Expanded(
                  child: BlocBuilder<CatalogCubit, CatalogState>(
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
                        CatalogLoaded() => Container(
                            color: AppColors.greyUltraLight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: catalogGridView(state.catalogs),
                            ),
                          ),
                      };
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget catalogGridView(List<Catalog> catalogs) {
    final filteredCatalogs = _selectedFilter == null
        ? catalogs
        : catalogs.where((catalog) {
            if (_selectedFilter is Family) {
              return catalog.family.contains(_selectedFilter as Family);
            } else if (_selectedFilter is Environment) {
              return catalog.environment == _selectedFilter;
            }
            return true;
          }).toList();

    if (filteredCatalogs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text(
            'Aucun résultat',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 100),
      child: ListView(
        children: filteredCatalogs
            .map((catalog) => CatalogCardItem(catalog: catalog))
            .toList(),
      ),
    );
  }

  Widget buildFamilyFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Row(
        children: [
          _buildFilterTab(null, label: 'Toutes'),
          ...Environment.values.map((env) => _buildFilterTab(env)),
          ...Family.values.map((family) => _buildFilterTab(family)),
        ],
      ),
    );
  }

  Widget _buildFilterTab(Object? filter, {String? label}) {
    final isSelected = _selectedFilter == filter;

    final textLabel = label ??
        switch (filter) {
          Family family => family.familyName,
          Environment env => env.envName,
          _ => 'unknown',
        };

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textLabel,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.greenDark : AppColors.greyMedium,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            if (isSelected)
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.greenDark,
                ),
              )
            else
              const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
