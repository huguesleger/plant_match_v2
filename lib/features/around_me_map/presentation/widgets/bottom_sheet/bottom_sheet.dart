import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card.dart';
import 'package:plant_match_v2/features/around_me_map/catalog_users/catalog_users.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/bottom_sheet/bottom_sheet_action.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/bottom_sheet/bottom_sheet_header.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

void bottomSheet({
  required BuildContext context,
  required ProfilUser user,
  required List<Catalog> catalogs,
  double? distance,
}) {
  AppBottomSheet.showBottomSheet(
    context,
    SizedBox(
      height: 490,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.paddingHorizontal,
            child: BottomSheetHeader(user: user, distance: distance),
          ),
          const SizedBox(height: 20),
          _CatalogSection(user: user, catalogs: catalogs),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: BottomSheetAction(userId: user.uid),
          ),
        ],
      ),
    ),
  );
}

class _CatalogSection extends StatelessWidget {
  const _CatalogSection({required this.user, required this.catalogs});
  final ProfilUser user;
  final List<Catalog> catalogs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      color: AppColors.greyUltraLight,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: catalogs.isNotEmpty
          ? Row(
              children: [
                const SizedBox(width: 16),
                AppCard(
                  bgColor: AppColors.greenDark,
                  textColor: AppColors.white,
                  title: t.aroundMeMap.bottomSheet.title,
                  description: t.aroundMeMap.bottomSheet.description,
                  icon: LucideIcons.flower_2,
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                Expanded(child: CatalogUsers(catalogs: catalogs)),
              ],
            )
          : Center(
              child: Text(
                t.aroundMeMap.catalogUsers.userNoCatalog(
                  name: user.userName.match(
                    () =>
                        user.fullName.getFirstWordBeforeSpace().toCapitalize(),
                    (userName) => userName.toCapitalize(),
                  ),
                ),
                textAlign: TextAlign.center,
                style: InterTextStyle.inter(
                  AppTypo.textM,
                  color: AppColors.greyDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }
}
