import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/widgets/skeleton/app_skeletonizer.dart';
import 'package:plant_match_v2/core/widgets/template/template_page.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/home/domain/entities/home.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_recommendation.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/around_me/home_around_me_section.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_recent_activity.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/recommendation/home_recommendation_content.dart';
import 'package:plant_match_v2/features/recent_activity/presentation/recent_activity_page_route.dart';

class HomeSections extends StatelessWidget {
  const HomeSections({
    super.key,
    required this.home,
    required this.recommendation,
    required this.isLoading,
  });

  final Home home;
  final HomeRecommendation recommendation;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppSkeletonizer(
              enabled: isLoading,
              child: HomeAroundMeSection(
                plants: home.nearbyPlants,
                isGeolocated: home.isGeolocated,
                onSeeAllPressed: () => _openMap(context),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: HomeRecommendationContent(
              recommendation: recommendation,
              isLoading: isLoading,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AppSkeletonizer(
              enabled: isLoading,
              child: HomeRecentActivity(
                activities: home.recentActivities,
                onSeeAllPressed: () => _openRecentActivity(context),
              ),
            ),
          ),
        ],
      );

  void _openMap(BuildContext context) =>
      Option.fromNullable(context.findAncestorStateOfType<TemplatePageState>())
          .map((page) => page.onPageChanged(1));

  void _openRecentActivity(BuildContext context) {
    final aroundMeCubit = context.read<AroundMeCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecentActivityPageRoute(aroundMeCubit: aroundMeCubit),
      ),
    );
  }
}
