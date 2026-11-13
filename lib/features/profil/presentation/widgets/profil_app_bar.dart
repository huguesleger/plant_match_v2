import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/avatar/avatar.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class ProfilAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfilAppBar({
    super.key,
    required this.profilUser,
    required this.isLoading,
    this.isAvatarLoading = false,
  });

  final ProfilUser profilUser;
  final bool isLoading;
  final bool isAvatarLoading;

  static const double _height = 70;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) => AppBarTemplate(
        titleWidget: Some(
          AppSkeletonizer(
            enabled: isLoading,
            child: TitlePage(
              fontSize: AppTypo.textXl,
              title: profilUser.userName.match(
                () => profilUser.fullName.toCapitalizeWords(),
                (userName) => userName.toCapitalizeWords(),
              ),
              overflow: const Some(TextOverflow.ellipsis),
            ),
          ),
        ),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: const Some(AppColors.black),
        leading: false,
        leadingWith: 16,
        preferredHeight: _height,
        actions: Some([
          AppSkeletonizer(
            enabled: isLoading || isAvatarLoading,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
                border: Border.all(color: AppColors.white, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Avatar(
                profilUser: Some(profilUser),
                radius: 22,
                imgSizeAvatar: 44,
              ),
            ),
          ),
        ]),
      );
}
