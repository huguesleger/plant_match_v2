import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class ProfilBadgeCardHeader extends StatelessWidget {
  const ProfilBadgeCardHeader({
    super.key,
    required this.currentPoints,
    required this.level,
  });

  final int currentPoints;
  final int level;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        color: AppColors.greenMedium,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.star, color: AppColors.white),
                  const SizedBox(width: 10),
                  Text(
                    'Points',
                    style: InterTextStyle.inter(
                      AppTypo.textS,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currentPoints.toString(),
                    style: InterTextStyle.inter(
                      AppTypo.textXl,
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Niveau $level',
                    style: InterTextStyle.inter(
                      11,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
