import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/presentation/profil/domain/entity/profil_user.dart';

void bottomSheetUser({
  required BuildContext context,
  required ProfilUser user,
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
                Avatar(profilUser: user, radius: 45, imgSizeAvatar: 90),
                const SizedBox(width: 10),
                Column(
                  children: [
                    TitlePage(
                      title: user.userName.toCapitalize(),
                      fontSize: AppTypo.text,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w500,
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
                            : AppColors.greyUltraLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: AppColors.greenLight,
                            size: 6,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            user.isOnline ? "En ligne" : "Hors ligne",
                            style: const TextStyle(
                              color: AppColors.white,
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
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
