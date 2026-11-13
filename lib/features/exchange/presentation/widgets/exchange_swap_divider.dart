import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

class ExchangeSwapDivider extends StatelessWidget {
  const ExchangeSwapDivider({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            const Expanded(child: Divider(color: AppColors.greyLight)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.greenLight.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.arrow_up_down,
                color: AppColors.blueGreen,
                size: 22,
              ),
            ),
            const Expanded(child: Divider(color: AppColors.greyLight)),
          ],
        ),
      );
}
