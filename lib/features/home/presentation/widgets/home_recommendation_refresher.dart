import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/saved_recommendation_cubit.dart';

class HomeRecommendationRefresher extends StatelessWidget {
  const HomeRecommendationRefresher({
    super.key,
    required this.uid,
    required this.child,
  });

  final String uid;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocListener<AroundMeCubit, AroundMeState>(
        listenWhen: (previous, current) => switch ((previous, current)) {
          (
            AroundMeLoaded(userCatalogs: final before),
            AroundMeLoaded(userCatalogs: final after)
          ) =>
            !identical(before, after),
          _ => false,
        },
        listener: (context, _) => context
            .read<SavedRecommendationCubit>()
            .refreshRecommendations(uid),
        child: child,
      );
}
