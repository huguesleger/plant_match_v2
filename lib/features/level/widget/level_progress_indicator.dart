import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

class LevelProgressIndicator extends StatelessWidget {
  const LevelProgressIndicator({
    super.key,
    required this.currentPoints,
    required this.level,
  });

  final int currentPoints;
  final int level;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _LevelLabel(
                  prefix: t.level.progress.level_prefix, value: '$level'),
              UserPointsUtils.getNextLevel(level).match(
                () =>
                    _LevelLabel(prefix: t.level.progress.max_level, value: ''),
                (next) => _LevelLabel(
                  prefix: t.level.progress.level_prefix,
                  value: '$next',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: UserPointsUtils.progressionFor(currentPoints, level),
            backgroundColor: AppColors.blueGreen.withValues(alpha: 0.3),
            color: AppColors.greenMedium,
            minHeight: 2,
          ),
        ],
      );
}

class _LevelLabel extends StatelessWidget {
  const _LevelLabel({required this.prefix, required this.value});

  final String prefix;
  final String value;

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: prefix,
          style: const TextStyle(
            fontSize: AppTypo.textS,
            color: AppColors.greenMedium,
          ),
          children: [
            TextSpan(
              text: value,
              style: InterTextStyle.inter(
                AppTypo.textS,
                color: AppColors.greenMedium,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}
