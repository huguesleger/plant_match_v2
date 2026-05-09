import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
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
          child: TitlePage(
            title: t.catalog.screen.title,
            subtitle: t.catalog.screen.subtitle,
          ),
        ),
        const SizedBox(height: 90),
        const Padding(
          padding: AppSpacing.paddingHorizontal,
          child: CatalogCardIsEmpty(),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Column(
            children: [
              Assets.res.images.emptyCatalogFilter.image(
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                t.catalog.screen.empty_message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
