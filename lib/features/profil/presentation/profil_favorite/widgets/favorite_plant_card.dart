import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class FavoritePlantCard extends StatelessWidget {
  const FavoritePlantCard({
    super.key,
    required this.plant,
    required this.onRemove,
    required this.onTap,
  });

  final Map<String, dynamic> plant;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = plant['name'] as String? ?? '';
    final imageUrl = plant['imageUrl'] as String? ?? '';
    final isAvailable = plant['isAvailable'] as bool? ?? true;
    final offerTypeRaw = plant['offerType'] as String?;
    final environmentRaw = plant['environment'] as String?;

    OfferType? offerType;
    if (offerTypeRaw != null) {
      offerType = OfferType.values.byName(offerTypeRaw);
    }

    Environment? environment;
    if (environmentRaw != null) {
      environment = Environment.values.byName(environmentRaw);
    }

    final isDonation = offerType == OfferType.donation;

    return Material(
      elevation: 4,
      shadowColor: AppColors.black.withValues(alpha: 0.15),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.greyUltraLight),
      ),
      color: AppColors.white,
      child: InkWell(
        onTap: isAvailable ? onTap : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image avec overlay "Non disponible"
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                if (!isAvailable)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      child: ColoredBox(
                        color: AppColors.black.withValues(alpha: 0.4),
                        child: const Center(
                          child: Icon(
                            Icons.block_rounded,
                            color: AppColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Contenu
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badges
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (!isAvailable)
                          BadgePill(
                            text: Text(
                              'Non disponible',
                              style: InterTextStyle.inter(
                                AppTypo.textXxs,
                                color: AppColors.white,
                              ),
                            ),
                            badgeColor: AppColors.red,
                          ),
                        if (offerType != null)
                          BadgePill(
                            text: Text(
                              offerType.offerTypeName,
                              style: InterTextStyle.inter(
                                AppTypo.textXxs,
                                color: isDonation
                                    ? AppColors.white
                                    : AppColors.greenLight,
                              ),
                            ),
                            badgeColor: isDonation
                                ? AppColors.greenMedium
                                : AppColors.blueGreen,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name.toCapitalize(),
                      style: InterTextStyle.inter(
                        AppTypo.textS,
                        fontWeight: FontWeight.w700,
                        color: isAvailable
                            ? AppColors.greyDark
                            : AppColors.greyMedium,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (environment != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Plante ${environment.envName}',
                        style: InterTextStyle.inter(
                          AppTypo.textXs,
                          color: AppColors.greyMedium,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    // Bouton retirer
                    GestureDetector(
                      onTap: onRemove,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            color: AppColors.greenMedium,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Retirer',
                            style: InterTextStyle.inter(
                              AppTypo.textXs,
                              color: AppColors.greenMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 110,
      height: 110,
      color: AppColors.greyUltraLight,
      child:
          const Icon(Icons.eco_rounded, color: AppColors.greyLight, size: 32),
    );
  }
}
