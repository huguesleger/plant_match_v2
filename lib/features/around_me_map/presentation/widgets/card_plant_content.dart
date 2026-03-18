import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class CardPlantContent extends StatelessWidget {
  const CardPlantContent({
    super.key,
    required this.catalog,
  });

  final Catalog catalog;

  @override
  Widget build(BuildContext context) {
    final offerTypeDonation = catalog.offerType == OfferType.donation;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            catalog.name.toCapitalize(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              fontSize: AppTypo.text,
              fontWeight: FontWeight.w600,
              color: AppColors.greyMedium,
            ),
          ),
          _buildEnvironmentInfo(),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: BadgePill(
              text: Text(
                catalog.offerType.offerTypeName,
                style: TextStyle(
                  fontSize: AppTypo.textXs,
                  color: offerTypeDonation ? AppColors.white : AppColors.greenLight,
                ),
              ),
              badgeColor: offerTypeDonation ? AppColors.greenMedium : AppColors.blueGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentInfo() {
    return Row(
      children: [
        Text(
          'plante ${catalog.environment.envName}',
          style: const TextStyle(
            fontSize: AppTypo.textXs,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 5),
        ClipOval(
          child: Container(
            color: AppColors.greenLight.withValues(alpha: 0.5),
            width: 25,
            height: 25,
            child: Icon(
              catalog.environment == Environment.outdoor ? LucideIcons.trees : LucideIcons.house,
              color: AppColors.blueGreen,
              size: AppTypo.textS,
            ),
          ),
        ),
      ],
    );
  }
}
