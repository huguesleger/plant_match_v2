import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppTypo.textL,
              fontWeight: FontWeight.w600,
              fontFamily: 'Chillax',
              color: AppColors.blueGreen,
            ),
            textAlign: TextAlign.center,
          ),
          child,
        ],
      ),
    );
  }
}
