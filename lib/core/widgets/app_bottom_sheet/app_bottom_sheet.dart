import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class AppBottomSheet {
  static Future<T?> showBottomSheet<T>(BuildContext context, Widget child) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: child,
        );
      },
    );
  }
}
