import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';

/// Affichée quand aucune plante n'est trouvée dans le rayon sélectionné.
/// Si le rayon est limité, propose de l'élargir ; sinon invite à publier.
void showNoPlantsBottomSheet({
  required BuildContext context,
  required bool isRadiusLimited,
  required VoidCallback onWidenRadius,
}) {
  AppBottomSheet.showBottomSheet(
    context,
    Builder(
      builder: (sheetContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.greyLight)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: TitlePage(
                title: t.aroundMeMap.map.empty_title,
                fontSize: AppTypo.textM,
                color: AppColors.greyDark,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.greenLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              LucideIcons.flower_2,
              color: AppColors.blueGreen,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: AppSpacing.paddingHorizontal,
            child: Text(
              isRadiusLimited
                  ? t.aroundMeMap.map.empty_widen
                  : t.aroundMeMap.map.empty_first,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.greyDark),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: AppSpacing.paddingHorizontal,
            child: SizedBox(
              width: double.infinity,
              child: ButtonRounded(
                text: isRadiusLimited
                    ? t.aroundMeMap.map.empty_widen_btn
                    : t.aroundMeMap.map.empty_close_btn,
                bgColor: AppColors.greenLight,
                textColor: AppColors.blueGreen,
                onPressed: Some(() {
                  Navigator.pop(sheetContext);
                  if (isRadiusLimited) onWidenRadius();
                }),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
