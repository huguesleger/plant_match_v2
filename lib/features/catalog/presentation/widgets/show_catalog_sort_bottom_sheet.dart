import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/catalog/presentation/widgets/catalog_sort_option.dart';

void showCatalogSortBottomSheet({
  required BuildContext context,
  required CatalogSortOption currentSortOption,
  required ValueChanged<CatalogSortOption> onSortApplied,
}) {
  CatalogSortOption localSortOption = currentSortOption;
  AppBottomSheet.showBottomSheet(
    context,
    StatefulBuilder(
      builder: (context, setModalState) {
        return SafeArea(
          child: RadioGroup<CatalogSortOption>(
            groupValue: localSortOption,
            onChanged: (val) {
              if (val != null) {
                setModalState(() {
                  localSortOption = val;
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.greyLight,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TitlePage(
                        title: t.catalog.sort.title,
                        fontSize: AppTypo.textM,
                        color: AppColors.greyDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                ...CatalogSortOption.values.map(
                  (option) => RadioListTile<CatalogSortOption>(
                    title: Text(option.label),
                    value: option,
                    activeColor: AppColors.blueGreen,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: AppSpacing.paddingHorizontal,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: AppSpacing.paddingHorizontal,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.greenLight,
                      foregroundColor: AppColors.blueGreen,
                    ),
                    onPressed: () {
                      onSortApplied(localSortOption);
                      Navigator.pop(context);
                    },
                    child: Text(t.catalog.sort.btn),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
