import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/extension/first_word_before_space/first_word_after_space.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class AvatarWithInfos extends StatelessWidget {
  const AvatarWithInfos({super.key, required this.user});

  final ProfilUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: Avatar(
                profilUser: user,
                radius: 45,
                imgSizeAvatar: 70,
                defaultSizeAvatar: 65,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: user.isOnline ? AppColors.greenLight : AppColors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          user.userName.isNotEmpty
              ? user.userName.toCapitalize()
              : user.fullName.getFirstWordBeforeSpace().toCapitalize(),
          style: InterTextStyle.inter(
            AppTypo.textM,
            color: AppColors.greyDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${user.localisation} (${user.zipCode})',
          style: InterTextStyle.inter(
            AppTypo.textXs,
            color: AppColors.greyDark,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
