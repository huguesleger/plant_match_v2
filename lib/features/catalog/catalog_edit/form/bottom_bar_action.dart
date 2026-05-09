import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded_with_icon.dart';

class BottomBarAction extends StatelessWidget {
  const BottomBarAction({
    super.key,
    required this.onSave,
  });

  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      child: ButtonRoundedWithIcon(
        text: t.catalog.edit.save,
        onPressed: onSave,
        bgColor: AppColors.greenLight,
        textColor: AppColors.blueGreen,
        iconAlignment: IconAlignment.start,
        icon: const Icon(LucideIcons.upload, color: AppColors.blueGreen),
      ),
    );
  }
}
