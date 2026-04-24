import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/card/user_plant_card.dart';

class CatalogList extends StatelessWidget {
  final List<Catalog> catalogs;

  const CatalogList({
    super.key,
    required this.catalogs,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontal,
      child: catalogs.isEmpty
          //TODO: Change this style
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "Aucune plante",
                style: InterTextStyle.inter(
                  AppTypo.text,
                  color: AppColors.greyMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : ListView.separated(
              itemCount: catalogs.length,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = catalogs[index];
                return UserPlantCard(
                  title: item.name,
                  subtitle: item.description,
                  imageUrl: item.images.first,
                  offerType: item.offerType,
                  environment: item.environment,
                  createdDate: item.createdAt,
                  catalog: item,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPlant(catalog: item),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
