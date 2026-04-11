import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class WizardProgressIndicator extends StatelessWidget {
  const WizardProgressIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: (currentPage + 1) / totalPages,
        end: (currentPage + 1) / totalPages,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: AppColors.greyLight,
          color: AppColors.greenLight,
          minHeight: 2,
        );
      },
    );
  }
}
