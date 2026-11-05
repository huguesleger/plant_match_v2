import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class DecorationInput {
  static InputDecoration inputDecoration({
    required String hintText,
    required String labelText,
    Option<String> helperText = const None(),
    Option<Widget> suffixIcon = const None(),
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      helperText: helperText.toNullable(),
      suffixIcon: suffixIcon.toNullable(),
      alignLabelWithHint: alignLabelWithHint,
      errorStyle: const TextStyle(
        color: AppColors.error,
      ),
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
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
