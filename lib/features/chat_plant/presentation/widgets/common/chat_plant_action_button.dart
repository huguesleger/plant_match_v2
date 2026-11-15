import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';

class ChatPlantActionButton extends StatelessWidget {
  const ChatPlantActionButton({
    super.key,
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.greyLight)),
        ),
        child: ButtonRoundedWithIcon(
          text: label,
          onPressed: onPressed,
          bgColor: backgroundColor,
          textColor: AppColors.white,
          icon: Icon(icon, color: AppColors.white),
          iconAlignment: IconAlignment.start,
        ),
      );
}
