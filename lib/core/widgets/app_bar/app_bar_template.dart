import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class AppBarTemplate extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTemplate({
    super.key,
    this.leadingWith = 76,
    this.title = const None(),
    this.centerTitle = false,
    required this.backgroundColor,
    this.shadowColor = const None(),
    required this.surfaceTintColor,
    this.styleIconButton = const None(),
    this.onPressed = const None(),
    this.actions = const None(),
    this.leading = true,
    this.actionsPadding = AppSpacing.paddingHorizontal,
    this.titleWidget = const None(),
    this.preferredHeight = 56,
  });

  final double leadingWith;
  final Option<String> title;
  final Option<Widget> titleWidget;
  final bool centerTitle;
  final Color backgroundColor;
  final Option<Color> shadowColor;
  final Color surfaceTintColor;
  final Option<ButtonStyle> styleIconButton;
  final Option<VoidCallback> onPressed;
  final Option<List<Widget>> actions;
  final bool leading;
  final EdgeInsets actionsPadding;
  final double preferredHeight;

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: preferredHeight,
      title: titleWidget
          .alt(
            () => title.map<Widget>(
              (value) => Text(
                value,
                style: const TextStyle(
                  color: AppColors.greyDark,
                  fontSize: AppTypo.textM,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.chillax,
                ),
              ),
            ),
          )
          .toNullable(),
      centerTitle: centerTitle,
      titleSpacing: 0,
      leadingWidth: leadingWith,
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: shadowColor.toNullable(),
      surfaceTintColor: surfaceTintColor,
      leading: leading
          ? IconButton(
              onPressed: onPressed.toNullable(),
              style: styleIconButton.toNullable(),
              icon: const Icon(
                LucideIcons.chevron_left,
                color: AppColors.greyDark,
              ),
            )
          : const SizedBox.shrink(),
      actions: actions.toNullable(),
      actionsPadding: actions.map((_) => actionsPadding).toNullable(),
    );
  }
}
