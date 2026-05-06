import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class DialogWithImage extends StatelessWidget {
  const DialogWithImage({
    super.key,
    required this.title,
    required this.text,
    required this.imagePath,
  });

  final String title;
  final String text;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: AppTypo.textL,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.chillax,
                color: AppColors.blueGreen,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(
                color: AppColors.greyMedium,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ButtonOutlinedRounded(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    text: 'Annuler',
                    borderColor: AppColors.greyLight,
                    textColor: AppColors.greyMedium,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ButtonRounded(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    text: 'Confirmer',
                    bgColor: AppColors.greenLight,
                    textColor: AppColors.blueGreen,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
