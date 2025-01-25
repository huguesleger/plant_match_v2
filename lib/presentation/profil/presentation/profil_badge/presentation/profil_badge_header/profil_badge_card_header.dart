import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

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
              const Row(
                children: [
                  Icon(LucideIcons.star, color: AppColors.white),
                  SizedBox(width: 10),
                  Text(
                    'Points',
                    style: TextStyle(
                      fontSize: 14,
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
                    style: const TextStyle(
                      fontSize: 24,
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Niveau $level',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
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
