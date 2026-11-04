import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/theme/inter_text_style.dart';
import 'package:plant_match_v2/features/level/level_detail/utils/user_level_details.dart';

class LevelDetailContent extends StatelessWidget {
  const LevelDetailContent({
    super.key,
    required this.levelData,
  });

  final LevelDetail levelData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LevelDetailRow(
          label: t.level.detail.conditions,
          value: levelData.condition,
        ),
        const SizedBox(height: 20),
        _LevelDetailRow(
          label: t.level.detail.description,
          value: levelData.description,
        ),
        const SizedBox(height: 20),
        _LevelDetailRow(
          label: t.level.detail.required_points,
          value: t.level.detail.points(n: levelData.requiredTransactions),
        ),
        const SizedBox(height: 20),
        _LevelDetailRow(
          label: t.level.detail.rewarded_actions_title,
          value: ' ${levelData.reward}',
        ),
      ],
    );
  }
}

class _LevelDetailRow extends StatelessWidget {
  const _LevelDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: InterTextStyle.inter(
          AppTypo.textS,
          fontWeight: FontWeight.w600,
          color: AppColors.greyDark,
        ),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: InterTextStyle.inter(
              AppTypo.textS,
              fontWeight: FontWeight.w400,
              color: AppColors.greyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
