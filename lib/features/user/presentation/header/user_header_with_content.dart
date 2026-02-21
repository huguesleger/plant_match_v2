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
    final topPadding = MediaQuery.of(context).padding.top + 40;
    return AppBarDynamicHeader(
      height: 160 + topPadding,
      titlePadding: const EdgeInsets.only(bottom: 0),
      titlePaddingShrink: const EdgeInsets.only(bottom: 0),
      collapsedHeight: kToolbarHeight + topPadding,
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
      visual: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 95,
            color: AppColors.white,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: AvatarWithInfos(user: user),
            ),
          ),
        ],
      ),
      shrinkVisual: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: AvatarWithInfos(user: user),
            ),
          ),
        ],
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
