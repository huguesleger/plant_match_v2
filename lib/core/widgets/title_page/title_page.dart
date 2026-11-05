import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';

class TitlePage extends StatelessWidget {
  const TitlePage({
    super.key,
    required this.title,
    this.subtitle = const None(),
    this.fontSize = 32,
    this.color = AppColors.blueGreen,
    this.fontWeight = FontWeight.w600,
    this.textAlign = const None(),
    this.overflow = const None(),
  });

  final String title;
  final Option<String> subtitle;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final Option<TextAlign> textAlign;
  final Option<TextOverflow> overflow;

  @override
  Widget build(BuildContext context) {
    return subtitle.filter((s) => s.isNotEmpty).match(
          () => Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: FontFamily.chillax,
              color: color,
              fontWeight: fontWeight,
              overflow: overflow.toNullable(),
            ),
          ),
          (sub) => Column(
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
                textAlign: textAlign.toNullable(),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontSize: AppTypo.text,
                  color: color,
                ),
                textAlign: textAlign.toNullable(),
              ),
            ],
          ),
        );
  }
}
