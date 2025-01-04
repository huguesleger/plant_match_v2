import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class DecorationInput {
  static InputDecoration inputDecoration({
    required String hintText,
    required String labelText,
    String? helperText,
    Widget? suffixIcon,
    alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      helperText: helperText,
      suffixIcon: suffixIcon,
      alignLabelWithHint: alignLabelWithHint,
      isDense: true,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(
          color: AppColors.blueGreen,
        ),
      ),
    );
  }
}
