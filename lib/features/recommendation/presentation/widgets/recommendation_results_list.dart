import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_outlined_rounded.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_results.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/recommendation_card_item.dart';

class RecommendationResultsList extends StatelessWidget {
  const RecommendationResultsList({super.key, required this.results});

  final RecommendationResults results;

  String get _headline => results.matches.isNotEmpty
      ? t.recommendation.result.found(n: results.matches.length)
      : t.recommendation.result.no_exact_match;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _headline,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppTypo.text,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                ...results.matches
                    .map((plant) => RecommendationCardItem(scored: plant)),
                if (results.alternatives.isNotEmpty) ...[
                  if (results.matches.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 32, bottom: 4),
                      child: Text(
                        t.recommendation.result.alternatives_title,
                        style: const TextStyle(
                          fontSize: AppTypo.textM,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ...results.alternatives
                      .map((plant) => RecommendationCardItem(scored: plant)),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ButtonOutlinedRounded(
                onPressed: context.read<RecommendationCubit>().reset,
                text: t.recommendation.result.retake,
                borderColor: AppColors.blueGreen,
                textColor: AppColors.blueGreen,
              ),
            ),
          ),
        ],
      );
}
