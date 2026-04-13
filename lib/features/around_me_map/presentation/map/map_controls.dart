import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class MapControls extends StatelessWidget {
  const MapControls({
    super.key,
    required this.onCenterOnUser,
    required this.onZoomIn,
    required this.onZoomOut,
  });

  final VoidCallback onCenterOnUser;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onCenterOnUser,
          backgroundColor: AppColors.white,
          mini: true,
          child: const Icon(
            LucideIcons.locate_fixed,
            color: AppColors.blueGreen,
            size: AppTypo.textM,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.3),
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onZoomIn,
                icon: const Icon(
                  LucideIcons.plus,
                  color: AppColors.blueGreen,
                  size: AppTypo.textM,
                ),
              ),
              Container(
                height: 1,
                width: 25,
                color: Colors.grey.shade300,
              ),
              IconButton(
                onPressed: onZoomOut,
                icon: const Icon(
                  LucideIcons.minus,
                  color: AppColors.blueGreen,
                  size: AppTypo.textM,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
