import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_bar/app_bar_template.dart';

class ExchangeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExchangeAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBarTemplate(
        title: Some(title),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: const Some(AppColors.black),
        styleIconButton: Some(
          IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: AppColors.greyLight),
          ),
        ),
        onPressed: Some(() => Navigator.pop(context)),
      );
}
