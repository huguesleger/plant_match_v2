import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/level_awarded_exit.dart';

class LevelAwardedSuccessView extends StatelessWidget {
  const LevelAwardedSuccessView({
    super.key,
    required this.leavesGained,
    required this.title,
    required this.description,
  });

  final int leavesGained;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Assets.res.images.visuLevelBadge.provider(),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: AppSpacing.paddingHorizontal,
          child: Column(
            children: [
              TitlePage(
                title: title,
                fontSize: AppTypo.textXl,
                fontWeight: FontWeight.bold,
                color: AppColors.blueGreen,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                style: InterTextStyle.inter(
                  AppTypo.text,
                  color: AppColors.greyDark,
                ),
              ),
              if (leavesGained > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.greenLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.leaf,
                        color: AppColors.greyDark,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.levelAwarded.rewards.leaves(n: leavesGained),
                        style: InterTextStyle.inter(
                          AppTypo.textL,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greyDark,
                        ),
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ButtonRounded(
                          text: t.levelAwarded.success.view_progression,
                          onPressed: Some(
                            () => Navigator.pop(
                              context,
                              const LevelAwardedViewProgression(),
                            ),
                          ),
                          bgColor: AppColors.white,
                          textColor: AppColors.blueGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
