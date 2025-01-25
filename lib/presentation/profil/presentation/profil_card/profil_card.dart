import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card.dart';
import 'package:plant_match_v2/presentation/profil/presentation/profil_badge/presentation/profil_badge_page.dart';

class ProfilCard extends StatelessWidget {
  const ProfilCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
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
                builder: (context) => ProfilBadgePage(userId: userId),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        AppCard(
          bgColor: AppColors.greenDark,
          textColor: AppColors.white,
          title: 'Plantes & Boutures',
          description: 'Mon catalogue de ce que j’ai à partager',
          icon: LucideIcons.flower_2,
          onPressed: () {},
        ),
        const SizedBox(width: 10),
        AppCard(
          bgColor: AppColors.greenDark,
          textColor: AppColors.white,
          title: 'Plantes & Boutures',
          description: 'Mon catalogue de ce que j’ai à partager',
          icon: LucideIcons.flower_2,
          onPressed: () {},
        ),
      ],
    );
  }
}
