import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded_with_icon.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/catalog_users/catalog_users.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/map_users/user_bottom_sheet_header.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/presentation/user_page_route.dart';

void bottomSheetUser({
  required BuildContext context,
  required ProfilUser user,
  required List<Catalog> catalogs,
  double? distance,
}) {
  AppBottomSheet.showBottomSheet(
    context,
    SizedBox(
      height: 550,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: AppSpacing.paddingHorizontal,
            child: UserBottomSheetHeader(user: user, distance: distance),
          ),
          const SizedBox(height: 20),
          _CatalogSection(user: user, catalogs: catalogs),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _ActionsSection(userId: user.uid),
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
                  title: 'Plantes & Boutures',
                  description: 'Mon catalogue de ce que j’ai à partager',
                  icon: LucideIcons.flower_2,
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                Expanded(child: CatalogUsers(catalogs: catalogs)),
              ],
            )
          : Center(
              child: Text(
                "${user.userName.match(
                  () => user.fullName.getFirstWordBeforeSpace().toCapitalize(),
                  (userName) => userName.toCapitalize(),
                )} n'a pas encore de catalogue.",
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

class _ActionsSection extends StatelessWidget {
  const _ActionsSection({required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingAll,
      child: ButtonOutlinedRoundedWithIcon(
        text: 'Voir le profil',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserPageRoute(uid: userId)),
          );
        },
        borderColor: AppColors.blueGreen,
        textColor: AppColors.blueGreen,
        iconAlignment: IconAlignment.start,
        icon: const Icon(LucideIcons.user_round, color: AppColors.blueGreen),
      ),
    );
  }
}
