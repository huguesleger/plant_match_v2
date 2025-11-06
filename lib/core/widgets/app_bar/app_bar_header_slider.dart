import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AppBarHeaderSlider extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarHeaderSlider({
    super.key,
    this.leading = true,
    required this.onPressed,
    this.styleIconButton,
    this.leadingWith = 76,
    this.headerHeight = 215,
    required this.content,
  });

  final bool? leading;
  final VoidCallback onPressed;
  final ButtonStyle? styleIconButton;
  final double? leadingWith;
  final double? headerHeight;
  final Widget content;

  @override
  Size get preferredSize => Size.fromHeight(headerHeight! - 59);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: content,
      leadingWidth: leadingWith,
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
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
