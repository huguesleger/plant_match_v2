import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeLeavesBadge extends StatelessWidget {
  const HomeLeavesBadge({super.key, required this.leaves});

  final int leaves;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) => Skeleton.replace(
        width: _size,
        height: _size,
        replacement: const Bone.circle(size: _size),
        child: Stack(
          children: [
            Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: AppColors.greyUltraLight,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.greyLight.withValues(alpha: 0.5),
                ),
              ),
              child: const Icon(
                LucideIcons.leaf,
                color: AppColors.black,
                size: 24,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.greenMedium,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  leaves.toString(),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: AppTypo.textXxs,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
}
