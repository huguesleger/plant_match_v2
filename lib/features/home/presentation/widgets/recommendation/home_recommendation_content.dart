import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/theme/app_typo.dart';
import 'package:plant_match_v2/core/widgets/error/error_content.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_recommendation.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/recommendation/home_recommendation_section.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/recommendation/home_recommended_banner.dart';
import 'package:plant_match_v2/features/recommendation/presentation/recommendation_page_route.dart';

class HomeRecommendationContent extends StatelessWidget {
  const HomeRecommendationContent({
    super.key,
    required this.recommendation,
    required this.isLoading,
  });

  final HomeRecommendation recommendation;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => AppSkeletonizer(
        enabled: isLoading || recommendation is HomeRecommendationLoading,
        child: switch (recommendation) {
          HomeRecommendationLoading(:final boneMocks) =>
            HomeRecommendationSection(
              plants: boneMocks,
              onAdjustPressed: () => _openQuestionnaire(context),
            ),
          HomeRecommendationMissing() => HomeRecommendedBanner(
              onPressed: () => _openQuestionnaire(context),
            ),
          HomeRecommendationLoaded(:final plants) => HomeRecommendationSection(
              plants: plants,
              onAdjustPressed: () => _openQuestionnaire(context),
            ),
          HomeRecommendationError(:final failure) => Center(
              child: Text(
                failure.errorContent.message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: AppTypo.textXs,
                ),
              ),
            ),
        },
      );

  Future<void> _openQuestionnaire(BuildContext context) {
    final homeCubit = context.read<HomeCubit>();
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecommendationPageRoute()),
    ).then((_) => homeCubit.loadRecommendations());
  }
}
