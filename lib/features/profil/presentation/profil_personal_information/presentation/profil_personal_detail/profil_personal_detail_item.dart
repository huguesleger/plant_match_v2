import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class ProfilPersonalDetailItem extends StatelessWidget {
  const ProfilPersonalDetailItem({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

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
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subtitle,
            style: const TextStyle(
                color: AppColors.greyMedium, fontSize: AppTypo.textXs),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          if (onTap != null)
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onTap,
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(LucideIcons.x, size: AppTypo.text),
                  ),
                ),
              ),
            ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
    );
  }
}
