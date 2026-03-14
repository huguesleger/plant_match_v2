import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class CarouselItem extends StatelessWidget {
  const CarouselItem({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;

  static const double defaultHeightImg = 315;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Column(
      children: [
        SizedBox(height: screenHeight * 0.08),
        SizedBox(
          height: screenHeight * 0.32,
          child: Image.asset(image, fit: BoxFit.contain),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppTypo.textXl,
              fontWeight: FontWeight.w600,
              fontFamily: 'Chillax',
              color: AppColors.blueGreen,
            ),
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppTypo.textXs,
            ),
          ),
        ),
      ],
    );
  }
}
