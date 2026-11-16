import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class DonationRequestCost extends StatelessWidget {
  const DonationRequestCost({super.key, required this.leaves});

  final Option<int> leaves;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.greyUltraLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(LucideIcons.leaf, color: AppColors.green, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                leaves.match(
                  () => t.chatPlant.donation_request.cost,
                  (n) => '${t.chatPlant.donation_request.cost} '
                      '${t.chatPlant.donation_request.remaining(n: n)}',
                ),
                style: InterTextStyle.inter(
                  AppTypo.textXs,
                  color: AppColors.greyMedium,
                ),
              ),
            ),
          ],
        ),
      );
}
