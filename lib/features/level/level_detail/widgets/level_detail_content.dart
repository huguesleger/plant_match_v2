import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';

class LevelDetailContent extends StatelessWidget {
  const LevelDetailContent({
    super.key,
    required this.levelData,
  });

  final Map<String, dynamic> levelData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: t.level.detail.conditions,
            style: InterTextStyle.inter(
              AppTypo.textS,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
            children: <TextSpan>[
              TextSpan(
                text: levelData['condition'],
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            text: t.level.detail.description,
            style: InterTextStyle.inter(
              AppTypo.textS,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
            children: <TextSpan>[
              TextSpan(
                text: levelData['description'],
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        RichText(
          text: TextSpan(
            text: t.level.detail.required_points,
            style: InterTextStyle.inter(
              AppTypo.textS,
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
            children: <TextSpan>[
              TextSpan(
                text: t.level.detail.points(n: levelData['requiredPoints'] as int),
                style: InterTextStyle.inter(
                  AppTypo.textS,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          t.level.detail.rewarded_actions_title,
          style: const TextStyle(
            fontSize: AppTypo.textS,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: (levelData['rewardedActions'] as Map<String, int>)
              .entries
              .map((entry) => Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: RichText(
                      text: TextSpan(
                        text: "• ${entry.key} : ",
                        style: InterTextStyle.inter(
                          AppTypo.textS,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greyDark,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "+${t.level.detail.points(n: entry.value)}",
                            style: InterTextStyle.inter(
                              AppTypo.textS,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
