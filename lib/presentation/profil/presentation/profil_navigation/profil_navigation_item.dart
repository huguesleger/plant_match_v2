import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class ProfilNavigationItem extends StatelessWidget {
  const ProfilNavigationItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.colorIcon = AppColors.blueGreen,
    this.colorBgIcon = AppColors.greenLight,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? colorIcon;
  final Color? colorBgIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: AppColors.black.withOpacity(0.2),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        tileColor: AppColors.white,
        leading: Container(
          width: 53,
          height: 53,
          decoration: BoxDecoration(
            color: colorBgIcon?.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: colorIcon),
        ),
        title: Text(
          title,
          style: const TextStyle(color: AppColors.greyMedium, fontSize: 14),
        ),
        trailing: const Icon(
          LucideIcons.chevron_right,
          color: AppColors.greyMedium,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
