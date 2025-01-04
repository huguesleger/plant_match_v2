import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AppTheme {
  static final ThemeData defaultTheme = _buildMyTheme();

  static ThemeData _buildMyTheme() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.blueGreen,
        secondary: AppColors.greenDark,
      ),
      buttonTheme: base.buttonTheme.copyWith(
        buttonColor: AppColors.greenLight,
        textTheme: ButtonTextTheme.primary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.greenLight,
        unselectedItemColor: AppColors.greyMedium,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.greenLight,
          foregroundColor: AppColors.blueGreen,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.blueGreen,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        backgroundColor: AppColors.greenLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          textStyle: const TextStyle(color: AppColors.blueGreen),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          foregroundColor: AppColors.greenLight,
          side: const BorderSide(
            color: AppColors.greenLight,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
      scaffoldBackgroundColor: AppColors.white,
      textTheme: GoogleFonts.interTextTheme(base.textTheme.copyWith(
        bodySmall: const TextStyle(color: AppColors.greyDark),
        bodyMedium: const TextStyle(color: AppColors.greyDark),
        bodyLarge: const TextStyle(color: AppColors.greyDark),
        labelSmall: const TextStyle(color: AppColors.greyDark),
        labelMedium: const TextStyle(color: AppColors.greyDark),
        labelLarge: const TextStyle(color: AppColors.greyDark),
        displaySmall: const TextStyle(color: AppColors.greyDark),
        displayMedium: const TextStyle(color: AppColors.greyDark),
        displayLarge: const TextStyle(color: AppColors.greyDark),
      )),
      bottomSheetTheme: const BottomSheetThemeData(
        dragHandleColor: AppColors.greyLight,
        dragHandleSize: Size(45, 4),
      ),
    );
  }
}
