import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/catalog_users/catalog_users.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

void bottomSheetUser({
  required BuildContext context,
  required ProfilUser user,
  required List<Catalog> catalogs,
  double? distance,
}) {
  AppBottomSheet.showBottomSheet(
    context,
    SizedBox(
      height: 450,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Avatar(
                  profilUser: user,
                  radius: 45,
                  imgSizeAvatar: 90,
                  defaultSizeAvatar: 65,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.userName.isNotEmpty
                          ? user.userName.toCapitalize()
                          : user.fullName
                              .getFirstWordBeforeSpace()
                              .toCapitalize(),
                      style: InterTextStyle.inter(
                        AppTypo.textM,
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: user.isOnline
                            ? AppColors.blueGreen
                            : AppColors.greyLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          user.isOnline
                              ? const Icon(
                                  Icons.circle,
                                  color: AppColors.greenLight,
                                  size: 6,
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(width: 2),
                          Text(
                            user.isOnline ? "En ligne" : "Hors ligne",
                            style: TextStyle(
                              color: user.isOnline
                                  ? AppColors.white
                                  : AppColors.greyDark,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (distance != null)
                  Column(
                    children: [
                      const Icon(
                        LucideIcons.map_pin,
                        color: AppColors.greenLight,
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "$distance km",
                          style: InterTextStyle.inter(
                            AppTypo.textS,
                            color: AppColors.greyDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 255,
            color: AppColors.greyUltraLight,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: catalogs.isNotEmpty
                ? Row(
                    children: [
                      const SizedBox(width: 20),
                      AppCard(
                        bgColor: AppColors.greenDark,
                        textColor: AppColors.white,
                        title: 'Plantes & Boutures',
                        description: 'Mon catalogue de ce que j’ai à partager',
                        icon: LucideIcons.flower_2,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 20),
                      CatalogUsers(catalogs: catalogs),
                    ],
                  )
                : Center(
                    child: Text(
                      "${user.userName.isNotEmpty ? user.userName.toCapitalize() : user.fullName.getFirstWordBeforeSpace().toCapitalize()} n'a pas encore de catalogue.",
                      style: InterTextStyle.inter(
                        AppTypo.textM,
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
          const Row(
            children: [
              Text('Envoyer un message'),
            ],
          ),
        ],
      ),
    ),
  );
}
