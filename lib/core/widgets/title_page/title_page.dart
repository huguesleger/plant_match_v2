import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({
    super.key,
    required this.title,
    this.subtitle,
    this.isSubtitle = false,
    this.fontSize = 32,
    this.color = AppColors.blueGreen,
    this.fontWeight = FontWeight.w600,
    this.textAlign,
    this.overflow,
  });

  final String title;
  final String? subtitle;
  final bool isSubtitle;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return isSubtitle != true
        ? Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'Chillax',
              color: color,
              fontWeight: fontWeight,
              overflow: overflow,
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Chillax',
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
          );
  }
}
