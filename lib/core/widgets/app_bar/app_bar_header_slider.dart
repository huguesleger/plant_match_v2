import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class AppBarHeaderSlider extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarHeaderSlider({
    super.key,
    this.leading = true,
    required this.onPressed,
    this.styleIconButton = const None(),
    this.leadingWith = 76,
    this.headerHeight = 215,
    required this.content,
    this.title = const None(),
    this.titleColor = AppColors.greyDark,
    this.actions = const None(),
    this.actionsPadding = AppSpacing.paddingHorizontal,
  });

  final bool leading;
  final VoidCallback onPressed;
  final Option<ButtonStyle> styleIconButton;
  final double leadingWith;
  final double headerHeight;
  final Widget content;
  final Option<String> title;
  final Color titleColor;
  final Option<List<Widget>> actions;
  final EdgeInsets actionsPadding;

  @override
  Size get preferredSize => Size.fromHeight(headerHeight - 59);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: content,
      leadingWidth: leadingWith,
      title: title
          .map<Widget>(
            (value) => Text(
              value,
              style: TextStyle(
                color: titleColor,
                fontSize: AppTypo.textM,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.chillax,
              ),
            ),
          )
          .toNullable(),
      leading: leading
          ? IconButton(
              onPressed: onPressed,
              style: styleIconButton.toNullable(),
              icon: const Icon(
                LucideIcons.chevron_left,
                color: AppColors.greyDark,
              ),
            )
          : const SizedBox.shrink(),
      elevation: 0,
      backgroundColor: AppColors.white,
      actions: actions.toNullable(),
      actionsPadding: actions.map((_) => actionsPadding).toNullable(),
      scrolledUnderElevation: 2,
      shadowColor: AppColors.black,
      surfaceTintColor: AppColors.white,
    );
  }
}
