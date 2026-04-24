import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class BadgeOfferType extends StatelessWidget {
  const BadgeOfferType({
    super.key,
    required this.offerType,
    this.fontSize = AppTypo.textXs,
  });

  final OfferType offerType;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return BadgePill(
      text: Text(
        offerType.offerTypeName,
        style: TextStyle(
          fontSize: fontSize,
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
