import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class LegalInformationItem extends StatelessWidget {
  const LegalInformationItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  static const double iconBoxSize = 52;
  static const double radius = 16;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: Row(
        children: [
          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: AppColors.greenLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Icon(
              icon,
              size: AppTypo.textL,
              color: AppColors.blueGreen,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: InterTextStyle.inter(
                AppTypo.textS,
                color: AppColors.greyDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
