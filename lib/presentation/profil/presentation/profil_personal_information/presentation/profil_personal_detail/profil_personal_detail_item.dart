import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class ProfilPersonalDetailItem extends StatelessWidget {
  const ProfilPersonalDetailItem({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: AppColors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.greyDark,
          fontSize: AppTypo.textS,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            color: AppColors.greyMedium, fontSize: AppTypo.textXs),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
    );
  }
}
