import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.bgColor,
    required this.textColor,
    required this.title,
    required this.description,
    required this.icon,
    required this.onPressed,
  });

  final Color bgColor;
  final Color textColor;
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      //margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.white),
                child: Icon(
                  icon,
                  color: AppColors.greenDark,
                  size: 14,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTypo.textL,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  fontSize: AppTypo.textXs,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ButtonRounded(
                  text: 'En voir +',
                  onPressed: onPressed,
                  bgColor: AppColors.blueGreen,
                  textColor: AppColors.white,
                  fontSize: AppTypo.textXs,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
