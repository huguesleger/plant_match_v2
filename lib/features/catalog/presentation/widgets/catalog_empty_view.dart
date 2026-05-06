import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_card_is_empty.dart';

class CatalogEmptyView extends StatelessWidget {
  const CatalogEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.paddingHorizontal + const EdgeInsets.only(top: 16),
          child: const TitlePage(
            title: 'Mes plantes',
            subtitle: 'Mon catalogue de plantes à partager',
          ),
        ),
        const SizedBox(height: 90),
        const Padding(
          padding: AppSpacing.paddingHorizontal,
          child: CatalogCardIsEmpty(),
        ),
        const SizedBox(height: 30),
        const Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Column(
            children: [
              Image(
                image: AssetImage('res/images/empty_catalog_filter.png'),
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
    );
  }
}
