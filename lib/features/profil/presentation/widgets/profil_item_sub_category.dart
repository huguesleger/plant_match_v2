import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class ProfilItemSubCategory extends StatelessWidget {
  const ProfilItemSubCategory({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.colorIcon = const None(),
    this.colorBgIcon = const None(),
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Option<Color> colorIcon;
  final Option<Color> colorBgIcon;

  static const double iconSize = 43;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          color: colorBgIcon.getOrElse(
            () => AppColors.greenLight.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: AppTypo.textM,
          color: colorIcon.getOrElse(() => AppColors.blueGreen),
        ),
      ),
      title: Text(
        title,
        style: InterTextStyle.inter(
          AppTypo.textS,
          color: AppColors.greyMedium,
        ),
      ),
      trailing: const Icon(
        LucideIcons.chevron_right,
        color: AppColors.greyMedium,
      ),
      onTap: onTap,
    );
  }
}
