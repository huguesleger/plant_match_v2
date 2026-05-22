import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/app_card/app_card_with_icon_square.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppCardWithIconSquare(
            icon: LucideIcons.trophy,
            title: t.level.cards.challenges.title,
            description: t.level.cards.challenges.description,
            bgColor: AppColors.greenMedium.withValues(alpha: 0.3),
            textColor: AppColors.greyDark,
            onPressed: () {
              // TODO: add onPressed to go to page
            },
            bgColorIcon: AppColors.greyUltraLight.withValues(alpha: 0.3),
            titleColor: AppColors.blueGreen,
            iconColor: AppColors.greyDark,
            textBtn: t.level.cards.discover,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: AppCardWithIconSquare(
            icon: LucideIcons.gift,
            title: t.level.cards.gifts.title,
            description: t.level.cards.gifts.description,
            bgColor: AppColors.greenMedium.withValues(alpha: 0.3),
            textColor: AppColors.greyDark,
            onPressed: () {
              // TODO: add onPressed to go to page
            },
            bgColorIcon: AppColors.greyUltraLight.withValues(alpha: 0.3),
            titleColor: AppColors.blueGreen,
            iconColor: AppColors.greyDark,
            textBtn: t.level.cards.discover,
          ),
        ),
      ],
    );
  }
}
