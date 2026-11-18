import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/gen/assets.gen.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/widgets/buttons/button_rounded.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_results.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/widgets/recommendation_results_list.dart';

class RecommendationResultView extends StatelessWidget {
  const RecommendationResultView({super.key, required this.results});

  final RecommendationResults results;

  @override
  Widget build(BuildContext context) => results.isEmpty
      ? const _EmptyResultsView()
      : RecommendationResultsList(results: results);
}

class _EmptyResultsView extends StatelessWidget {
  const _EmptyResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingHorizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.res.images.emptyCatalogFilter.image(height: 200),
            const SizedBox(height: 24),
            Text(
              t.recommendation.result.empty_title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.recommendation.result.empty_description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.greyDark),
            ),
            const SizedBox(height: 32),
            ButtonRounded(
              onPressed: Some(context.read<RecommendationCubit>().reset),
              text: t.recommendation.result.restart,
              bgColor: AppColors.greenLight,
              textColor: AppColors.blueGreen,
            ),
          ],
        ),
      ),
    );
  }
}
