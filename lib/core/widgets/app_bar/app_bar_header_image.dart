import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AppBarHeaderImage extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHeaderImage({
    super.key,
    required this.image,
    this.title,
    this.titleColor = AppColors.greyDark,
    this.leading = true,
    required this.onPressed,
    this.styleIconButton,
    this.leadingWith = 80,
    required this.headerHeight,
  });

  final Image image;
  final String? title;
  final Color? titleColor;
  final bool? leading;
  final VoidCallback onPressed;
  final ButtonStyle? styleIconButton;
  final double? leadingWith;
  final double headerHeight;

  @override
  Size get preferredSize => Size.fromHeight(headerHeight - 59);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      leadingWidth: leadingWith,
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                color: titleColor,
                fontSize: 18,
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
