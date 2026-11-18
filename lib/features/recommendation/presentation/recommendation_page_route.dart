import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/recommendation/data/repositories/recommendation_repository_impl.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/recommendation_screen.dart';

import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_state.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_location.dart';

class RecommendationPageRoute extends StatelessWidget {
  const RecommendationPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId.getOrElse(() => '');

    return BlocProvider(
      create: (context) => RecommendationCubit(
        repository: RecommendationRepositoryImpl(),
        userId: userId,
        location: _locationOf(context.read<AroundMeCubit>().state),
      )..startQuestionnaire(),
      child: const RecommendationScreen(),
    );
  }

  Option<RecommendationLocation> _locationOf(AroundMeState aroundMe) =>
      switch (aroundMe) {
        AroundMeLoaded(:final currentUser, :final users) => Some(
            RecommendationLocation(currentUser: currentUser, users: users),
          ),
        AroundMeInitial() ||
        AroundMeLoading() ||
        AroundMeError() =>
          const None(),
      };
}
