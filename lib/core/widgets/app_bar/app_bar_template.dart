import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AppBarTemplate extends StatelessWidget implements PreferredSizeWidget {
  const AppBarTemplate({
    super.key,
    this.leadingWith = 80,
    this.title,
    this.centerTitle = false,
    required this.backgroundColor,
    this.shadowColor,
    required this.surfaceTintColor,
    required this.styleIconButton,
    required this.onPressed,
  });

  final double? leadingWith;
  final String? title;
  final bool? centerTitle;
  final Color backgroundColor;
  final Color? shadowColor;
  final Color surfaceTintColor;
  final ButtonStyle styleIconButton;
  final VoidCallback onPressed;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: AppColors.greyDark,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Chillax',
              ),
            )
          : null,
      centerTitle: centerTitle,
      titleSpacing: 0,
      leadingWidth: leadingWith,
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      leading: IconButton(
/*        onPressed: () {
          Navigator.pop(context);
        },*/
        onPressed: onPressed,
        style: styleIconButton,
        icon: const Icon(LucideIcons.chevron_left, color: AppColors.greyDark),
      ),
    );
  }
}
