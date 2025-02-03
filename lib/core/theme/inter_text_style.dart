import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class InterTextStyle {
  static TextStyle inter(double size, {Color? color, FontWeight? fontWeight}) {
    return GoogleFonts.inter(
      fontSize: size,
      color: color ?? AppColors.greyDark,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }
}
