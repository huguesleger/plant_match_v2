import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card.dart';
import 'package:plant_match_v2/features/catalog/presentation/catalog_page_route.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_badge/presentation/profil_badge_page.dart';
import 'package:plant_match_v2/features/profil/presentation/profil_favorite/profil_favorite_page.dart';

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
          title: 'Plantes & Boutures',
          description: 'Mon catalogue de ce que j’ai à partager',
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
          title: 'Mes\nFavoris',
          description: 'Mes plantes et profils préférés',
          icon: LucideIcons.heart,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilFavoritePage(),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        AppCard(
          bgColor: AppColors.greenLight,
          textColor: AppColors.blueDark,
          title: 'Badges & Récompenses',
          description: 'Mes badges et mon niveau',
          icon: LucideIcons.award,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilBadgePage(),
              ),
            );
          },
        ),
      ],
    );
  }
}
