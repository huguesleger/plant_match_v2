import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/fonts.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/title_with_icon/title_with_icon.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/user/detail_plant/detail_plant.dart';
import 'package:plant_match_v2/features/user/presentation/widgets/card/recent_card.dart';

class RecentPlants extends StatelessWidget {
  const RecentPlants({
    super.key,
    required this.catalogs,
  });

  final List<Catalog> catalogs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Row(
            children: [
              TitleWithIcon(
                icon: LucideIcons.calendar_clock,
                iconColor: AppColors.greenLight,
                bgColor: AppColors.blueGreen,
                title: 'Ajouts Récents',
                fontSize: AppTypo.textM,
                fontColor: AppColors.blueGreen,
                fontFamily: FontFamily.chillax,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingHorizontal,
            itemCount: catalogs.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final item = catalogs[index];
              return SizedBox(
                width: 150,
                child: RecentCard(
                  name: item.name,
                  imageUrl: item.images.first,
                  recentDate: item.createdAt,
                  offerType: item.offerType,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPlant(
                          catalog: item,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
