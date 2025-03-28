import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class TitleWithIcon extends StatelessWidget {
  const TitleWithIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.bgColor,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Container(
            color: bgColor,
            width: 30,
            height: 30,
            child: Icon(icon, color: iconColor, size: AppTypo.text),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              color: AppColors.greyDark, fontSize: AppTypo.textS),
        ),
      ],
    );
  }
}
