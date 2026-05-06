import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/core/widgets/favorite_btn/favorite_btn.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class UserPlantCard extends StatelessWidget {
  const UserPlantCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onPressed,
    required this.offerType,
    required this.environment,
    required this.createdDate,
    this.catalog,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final OfferType offerType;
  final VoidCallback onPressed;
  final Environment environment;
  final DateTime createdDate;
  final Catalog? catalog;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('d/MM/y', 'fr_FR');
    final currentUserId = context.read<AuthCubit>().userId;
    return Material(
      elevation: 6,
      shadowColor: AppColors.black.withValues(alpha: 0.2),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.greyUltraLight,
          width: 1,
        ),
      ),
      color: AppColors.white,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 120,
                    height: 130,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: FavoriteBtn(
                      catalog: catalog,
                      currentUserId: currentUserId,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.paddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BadgePill(
                          text: Text(
                            offerType.offerTypeName,
                            style: TextStyle(
                              fontSize: AppTypo.textXxs,
                              color: offerType == OfferType.donation
                                  ? AppColors.white
                                  : AppColors.greenLight,
                            ),
                          ),
                          badgeColor: offerType == OfferType.donation
                              ? AppColors.greenMedium
                              : AppColors.blueGreen,
                        ),
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
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: InterTextStyle.inter(
                        AppTypo.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: InterTextStyle.inter(
                        AppTypo.textXs,
                        color: AppColors.greyMedium,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.user.card.added_on(date: date.format(createdDate)),
                      style: InterTextStyle.inter(
                        AppTypo.textXs,
                        color: AppColors.greyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
