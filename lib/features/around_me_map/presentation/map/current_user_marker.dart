import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class CurrentUserMarker extends StatelessWidget {
  const CurrentUserMarker({super.key});

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.greenMedium.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: AppColors.greenMedium,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
          ),
        ],
      );
}
