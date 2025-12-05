import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/app_bottom_sheet/app_bottom_sheet.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded_with_icon.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/catalog_users/catalog_users.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/presentation/cubit/user_cubit.dart';
import 'package:plant_match_v2/features/user/presentation/user_page.dart';

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
                      "${user.userName.isNotEmpty ? user.userName.toCapitalize() : user.fullName.getFirstWordBeforeSpace().toCapitalize()} n'a pas encore de catalogue.",
                      style: InterTextStyle.inter(
                        AppTypo.textM,
                        color: AppColors.greyDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: AppSpacing.paddingAll,
                  child: ButtonOutlinedRoundedWithIcon(
                    text: 'Voir le profil',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<UserCubit>(),
                            child: UserPage(uid: user.uid),
                          ),
                        ),
                      );
                    },
                    borderColor: AppColors.blueGreen,
                    textColor: AppColors.blueGreen,
                    iconAlignment: IconAlignment.start,
                    icon: const Icon(
                      LucideIcons.user_round,
                      color: AppColors.blueGreen,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
