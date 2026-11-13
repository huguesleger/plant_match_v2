import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/extension/capitalize/capitalize.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/badge/badge_pill.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/exchange/presentation/widgets/exchange_plant_image.dart';

class ExchangePlantCard extends StatelessWidget {
  const ExchangePlantCard({
    super.key,
    required this.plant,
    this.onTap = const None(),
  });

  final Catalog plant;
  final Option<VoidCallback> onTap;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 6,
        shadowColor: AppColors.black.withValues(alpha: 0.2),
        clipBehavior: Clip.antiAlias,
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.greyUltraLight),
        ),
        child: InkWell(
          onTap: onTap.toNullable(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ExchangePlantImage(plant: plant),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BadgePill(
                        text: Text(
                          plant.environment.envName,
                          style: InterTextStyle.inter(
                            AppTypo.textXxs,
                            color: AppColors.greenLight,
                          ),
                        ),
                        badgeColor: AppColors.blueGreen,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        plant.name.toCapitalize(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: InterTextStyle.inter(
                          AppTypo.textS,
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        plant.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: InterTextStyle.inter(
                          AppTypo.textXs,
                          color: AppColors.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                ...onTap.match(
                  () => const <Widget>[],
                  (_) => const [
                    SizedBox(width: 8),
                    Icon(LucideIcons.chevron_right,
                        color: AppColors.greyMedium),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
