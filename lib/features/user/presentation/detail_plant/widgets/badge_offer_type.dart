import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class BadgeOfferType extends StatelessWidget {
  const BadgeOfferType({super.key, required this.offerType});

  final OfferType offerType;

  @override
  Widget build(BuildContext context) {
    return BadgePill(
      text: Text(
        offerType.offerTypeName,
        style: TextStyle(
          fontSize: AppTypo.textXs,
          color: offerType == OfferType.donation
              ? AppColors.white
              : AppColors.greenLight,
        ),
      ),
      badgeColor: offerType == OfferType.donation
          ? AppColors.greenMedium
          : AppColors.blueGreen,
    );
  }
}
