import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class CardPlant extends StatelessWidget {
  const CardPlant({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.environment,
    required this.offerType,
    required this.onPressed,
  });

  final String imageUrl;
  final String name;
  final String description;
  final Environment environment;
  final OfferType offerType;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final offerTypeDonation = offerType == OfferType.donation;
    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 155,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const FavoriteBtn(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      name.toCapitalize(),
                      style: const TextStyle(
                        fontSize: AppTypo.text,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyMedium,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'plante ${environment.envName}',
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
                              environment == Environment.outdoor
                                  ? LucideIcons.trees
                                  : LucideIcons.house,
                              color: AppColors.blueGreen,
                              size: AppTypo.textS,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: BadgePill(
                        text: Text(
                          offerType.offerTypeName,
                          style: TextStyle(
                            fontSize: AppTypo.textXs,
                            color: offerTypeDonation
                                ? AppColors.white
                                : AppColors.greenLight,
                          ),
                        ),
                        badgeColor: offerTypeDonation
                            ? AppColors.greenMedium
                            : AppColors.blueGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
