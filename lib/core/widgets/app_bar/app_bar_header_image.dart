import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class AppBarHeaderImage extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHeaderImage({
    super.key,
    required this.image,
    this.title,
    this.titleColor = AppColors.greyDark,
    this.leading = true,
    required this.onPressed,
    this.styleIconButton,
    this.leadingWith = 76,
    this.headerHeight = 215,
    this.fit = BoxFit.cover,
    this.actions,
    this.actionsPadding = AppSpacing.paddingHorizontal,
  });

  final Image image;
  final String? title;
  final Color? titleColor;
  final bool? leading;
  final VoidCallback onPressed;
  final ButtonStyle? styleIconButton;
  final double? leadingWith;
  final double? headerHeight;
  final BoxFit? fit;
  final List<Widget>? actions;
  final EdgeInsets actionsPadding;

  @override
  Size get preferredSize => Size.fromHeight(headerHeight! - 59);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image.image,
            fit: fit,
          ),
        ),
      ),
      leadingWidth: leadingWith,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: titleColor,
                fontSize: AppTypo.textM,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.chillax,
              ),
            )
          : null,
      leading: leading == true
          ? IconButton(
              onPressed: onPressed,
              style: styleIconButton,
              icon: const Icon(
                LucideIcons.chevron_left,
                color: AppColors.greyDark,
              ),
            )
          : const SizedBox.shrink(),
      actions: actions,
      actionsPadding: actions != null ? actionsPadding : null,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
