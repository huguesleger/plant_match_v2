import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card_with_icon_square.dart';

class ProfilBadgeCard extends StatelessWidget {
  const ProfilBadgeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppCardWithIconSquare(
            icon: LucideIcons.trophy,
            title: 'Défis et récompenses',
            description: 'Participer à des défis, gagner des récompenses',
            bgColor: AppColors.greenMedium.withOpacity(0.3),
            textColor: AppColors.greyDark,
            onPressed: () {},
            bgColorIcon: AppColors.greyUltraLight.withOpacity(0.3),
            titleColor: AppColors.blueGreen,
            iconColor: AppColors.greyDark,
            textBtn: 'Découvrir',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: AppCardWithIconSquare(
            icon: LucideIcons.gift,
            title: 'Choisir mes cadeaux',
            description: 'Transformer vos points en cadeaux',
            bgColor: AppColors.greenMedium.withOpacity(0.3),
            textColor: AppColors.greyDark,
            onPressed: () {},
            bgColorIcon: AppColors.greyUltraLight.withOpacity(0.3),
            titleColor: AppColors.blueGreen,
            iconColor: AppColors.greyDark,
            textBtn: 'Découvrir',
          ),
        ),
      ],
    );
  }
}
