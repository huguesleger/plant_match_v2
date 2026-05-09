import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class EmptyHistoryView extends StatelessWidget {
  const EmptyHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.history,
            size: 64,
            color: AppColors.greyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            t.history.empty.message,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.greyDark,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
