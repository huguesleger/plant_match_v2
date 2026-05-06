import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/widgets/title_page/title_page.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/level/presentation/level_page_route.dart';

class LevelAwardedSuccessView extends StatelessWidget {
  const LevelAwardedSuccessView({
    super.key,
    required this.userPoints,
    required this.isFromRegistration,
  });

  final UserPoints userPoints;
  final bool isFromRegistration;

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
                title: isFromRegistration ? t.levelAwarded.success.welcome_title : t.levelAwarded.success.congrats_title,
                fontSize: AppTypo.textXl,
                fontWeight: FontWeight.bold,
                color: AppColors.blueGreen,
              ),
              const SizedBox(height: 5),
              Text.rich(
                TextSpan(
                  text: isFromRegistration
                       ? t.levelAwarded.success.welcome_desc
                       : t.levelAwarded.success.congrats_desc,
                  children: [
                    TextSpan(
                      text: t.levelAwarded.success.points(n: userPoints.currentPoints),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ButtonRounded(
                        text: t.levelAwarded.success.view_progression,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelPageRoute(),
                          ),
                        ),
                        bgColor: AppColors.white,
                        textColor: AppColors.blueGreen,
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
