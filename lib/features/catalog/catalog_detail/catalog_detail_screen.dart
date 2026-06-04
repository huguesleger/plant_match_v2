import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_header_slider.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/catalog/catalog_detail/widgets/catalog_detail_header.dart';
import 'package:plant_match_v2/features/catalog/catalog_detail/widgets/catalog_detail_basic_info.dart';
import 'package:plant_match_v2/features/catalog/catalog_detail/widgets/catalog_detail_characteristics.dart';
import 'package:plant_match_v2/features/catalog/catalog_detail/widgets/catalog_detail_actions.dart';

class CatalogDetailScreen extends StatefulWidget {
  const CatalogDetailScreen({super.key, required this.catalog});
  final Catalog catalog;

  @override
  State<CatalogDetailScreen> createState() => _CatalogDetailScreenState();
}

class _CatalogDetailScreenState extends State<CatalogDetailScreen> {
  late Catalog _catalog;

  @override
  void initState() {
    super.initState();
    _catalog = widget.catalog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHeaderSlider(
        headerHeight: 240,
        content: CatalogDetailHeader(images: _catalog.images),
        onPressed: () => Navigator.pop(context, true),
        styleIconButton: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
        ),
      ),
      body: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              CatalogDetailBasicInfo(catalog: _catalog),
              const SizedBox(height: 24),
              CatalogDetailCharacteristics(catalog: _catalog),
              const SizedBox(height: 24),
              Text(
                t.catalog.detail.description,
                style: const TextStyle(
                  fontSize: AppTypo.textL,
                  fontWeight: FontWeight.bold,
                  color: AppColors.greyDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _catalog.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        child: CatalogDetailActions(
          catalog: _catalog,
          onUpdate: (updatedCatalog) =>
              setState(() => _catalog = updatedCatalog),
        ),
      ),
    );
  }
}
