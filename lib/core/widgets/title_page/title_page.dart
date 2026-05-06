import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({
    super.key,
    required this.title,
    this.subtitle,
    this.fontSize = 32,
    this.color = AppColors.blueGreen,
    this.fontWeight = FontWeight.w600,
    this.textAlign,
    this.overflow,
  });

  final String title;
  final String? subtitle;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return subtitle != null && subtitle!.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: FontFamily.chillax,
                  color: color,
                  fontWeight: fontWeight,
                ),
                textAlign: textAlign,
              ),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: AppTypo.text,
                  color: color,
                ),
                textAlign: textAlign,
              ),
            ],
          )
        : Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: FontFamily.chillax,
              color: color,
              fontWeight: fontWeight,
              overflow: overflow,
            ),
          );
  }
}
