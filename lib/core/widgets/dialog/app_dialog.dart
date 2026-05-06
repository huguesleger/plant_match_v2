import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.child,
    required this.title,
    this.textAlign = TextAlign.center,
    this.titlePadding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final Widget child;
  final String title;
  final TextAlign textAlign;
  final EdgeInsets titlePadding;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: titlePadding,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: AppTypo.textL,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.chillax,
                color: AppColors.blueGreen,
              ),
              textAlign: textAlign,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
