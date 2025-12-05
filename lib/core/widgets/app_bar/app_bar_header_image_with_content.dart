import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class AppBarHeaderImageWithContent extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarHeaderImageWithContent({
    super.key,
    required this.image,
    required this.onPressed,
    required this.child,
    this.title,
    this.titleColor = AppColors.greyDark,
    this.leading = true,
    this.styleIconButton,
    this.leadingWith = 76,
    this.headerHeight = 215,
    this.fit = BoxFit.cover,
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
  final Widget child;

  @override
  Size get preferredSize => Size.fromHeight(headerHeight! - 59);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image.image,
                fit: fit,
              ),
            ),
          ),
          child,
        ],
      ),
      leadingWidth: leadingWith,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: titleColor,
                fontSize: AppTypo.textM,
                fontWeight: FontWeight.w600,
                fontFamily: 'Chillax',
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
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
