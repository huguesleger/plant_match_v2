import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/header/home_header.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.user,
    required this.leaves,
    required this.isLoading,
  });

  final ProfilUser user;
  final int leaves;
  final bool isLoading;

  static const double _height = 100;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) => AppBarTemplate(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: const Some(AppColors.black),
        leading: false,
        leadingWith: 0,
        preferredHeight: _height,
        titleWidget: Some(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSkeletonizer(
              enabled: isLoading,
              child: HomeHeader(user: user, leaves: leaves),
            ),
          ),
        ),
      );
}
