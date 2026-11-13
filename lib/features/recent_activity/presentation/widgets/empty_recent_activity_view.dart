import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class EmptyRecentActivityView extends StatelessWidget {
  const EmptyRecentActivityView({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          t.recentActivity.empty.message,
          style: const TextStyle(color: AppColors.greyMedium),
        ),
      );
}
