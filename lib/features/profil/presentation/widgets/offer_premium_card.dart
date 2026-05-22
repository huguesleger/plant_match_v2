import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';

class OfferPremiumCard extends StatelessWidget {
  const OfferPremiumCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card.filled(
          color: AppColors.greenMedium.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: SizedBox(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.white,
                          ),
                          child: const Icon(
                            LucideIcons.crown,
                            color: AppColors.greenDark,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          t.profil.premium.title,
                          style: const TextStyle(
                            fontSize: AppTypo.textM,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blueGreen,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            t.profil.premium.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: AppTypo.textXs,
                              color: AppColors.greyDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ButtonRounded(
                          text: t.profil.premium.btn,
                          bgColor: AppColors.blueGreen,
                          textColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          onPressed: () => {
                            //TODO: add onPressed to go to plant premium
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 80),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: -24,
          child: SizedBox(
            height: 220,
            child: Assets.res.images.emptyCatalog.image(
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
