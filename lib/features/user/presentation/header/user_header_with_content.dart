import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_dynamic_header.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/presentation/header/avatar_with_infos.dart';
import 'package:plant_match_v2/features/user/presentation/header/bg_header.dart';

class UserHeaderWithContent extends StatelessWidget {
  const UserHeaderWithContent({
    super.key,
    required this.child,
    required this.user,
  });

  final Widget child;
  final ProfilUser user;

  @override
  Widget build(BuildContext context) {
    return AppBarDynamicHeader(
      height: 240,
      titlePadding: const EdgeInsets.only(bottom: 16),
      collapsedHeight: 130,
      leadingButton: IconButton(
        style: IconButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.greyLight),
        ),
        icon: const Icon(
          LucideIcons.chevron_left,
          color: AppColors.greyDark,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      visual: AvatarWithInfos(
        user: user,
      ),
      shrinkVisual: AvatarWithInfos(
        user: user,
      ),
      backgroundAppBar: const BgHeader(),
      actions: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
              BorderSide(color: AppColors.greyLight),
            ),
          ),
          padding: const EdgeInsets.all(6),
          child: const FavoriteBtn(),
        ),
      ],
      body: child,
    );
  }
}
