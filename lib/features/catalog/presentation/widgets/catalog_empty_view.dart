import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';

class CatalogEmptyView extends StatelessWidget {
  const CatalogEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
