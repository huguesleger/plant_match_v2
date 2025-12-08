import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

class RecentCard extends StatelessWidget {
  const RecentCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.recentDate,
    required this.onPressed,
    required this.offerType,
  });

  final String imageUrl;
  final String name;
  final DateTime recentDate;
  final VoidCallback onPressed;
  final OfferType offerType;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('d/MM/y', 'fr_FR');
    final offerTypeDonation = offerType == OfferType.donation;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Card.filled(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
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
                Positioned(
                  bottom: 16,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: offerTypeDonation
                          ? AppColors.greenMedium
                          : AppColors.blueGreen,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: Text(
                      offerType.offerTypeName,
                      style: InterTextStyle.inter(
                        AppTypo.textS,
                        color: offerTypeDonation
                            ? AppColors.white
                            : AppColors.greenLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toCapitalize(),
                    style: InterTextStyle.inter(
                      AppTypo.textS,
                      color: AppColors.greyDark,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Ajouté le",
                    style: InterTextStyle.inter(
                      AppTypo.textXs,
                      color: AppColors.greyMedium,
                    ),
                  ),
                  Text(
                    date.format(recentDate),
                    style: InterTextStyle.inter(
                      AppTypo.textXs,
                      color: AppColors.greyMedium,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
