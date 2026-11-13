import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/core/widgets/filter/filter_bar.dart';
import 'package:plant_match_v2/core/widgets/refresh/refresh_screen.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/home/domain/entities/home.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_recommendation.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_sections.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.uid,
    required this.home,
    required this.filter,
    required this.recommendation,
    required this.isLoading,
  });

  final String uid;
  final Home home;
  final CatalogFilter filter;
  final HomeRecommendation recommendation;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterBar<CatalogFilter>(
            filters: CatalogFilter.values,
            selected: filter,
            onChanged: context.read<HomeCubit>().selectFilter,
            labelBuilder: (f) => f.label,
            iconBuilder: (f) => f.icon,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: HomeSections(
              home: home,
              recommendation: recommendation,
              isLoading: isLoading,
            ),
          ),
        ],
      ),
    );

    return isLoading
        ? content
        : RefreshScreen(
            onRefresh: () => context.read<AroundMeCubit>().refresh(uid),
            child: content,
          );
  }
}
