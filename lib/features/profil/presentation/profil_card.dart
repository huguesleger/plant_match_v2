import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card.dart';
import 'package:plant_match_v2/features/catalog/presentation/catalog_page_route.dart';
import 'package:plant_match_v2/features/level/presentation/level_page_route.dart';
import 'package:plant_match_v2/features/favorite/presentation/favorite_page_route.dart';

class ProfilCard extends StatelessWidget {
  const ProfilCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: AppSpacing.paddingHorizontal,
      children: [
        AppCard(
          bgColor: AppColors.greenDark,
          textColor: AppColors.white,
          title: t.profil.cards.catalog.title,
          description: t.profil.cards.catalog.description,
          icon: LucideIcons.flower_2,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CatalogPageRoute(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        AppCard(
          bgColor: AppColors.greenMedium,
          textColor: AppColors.white,
          title: t.profil.cards.favorites.title,
          description: t.profil.cards.favorites.description,
          icon: LucideIcons.heart,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritePageRoute(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        AppCard(
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueGreen,
          title: t.profil.cards.awards.title,
          description: t.profil.cards.awards.description,
          icon: LucideIcons.award,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LevelPageRoute(),
              ),
            );
          },
        ),
      ],
    );
  }
}
