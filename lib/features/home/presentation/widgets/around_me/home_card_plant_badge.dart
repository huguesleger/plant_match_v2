import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeCardPlantBadge extends StatelessWidget {
  const HomeCardPlantBadge({super.key, required this.offerType});

  final OfferType offerType;

  @override
  Widget build(BuildContext context) {
    final isExchange = offerType == OfferType.exchange;
    return Skeleton.leaf(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isExchange ? AppColors.blueGreen : AppColors.greenMedium,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          isExchange ? t.home.card.exchange : t.home.card.donation,
          style: TextStyle(
            color: isExchange ? AppColors.green : AppColors.white,
            fontSize: AppTypo.textXxs,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
