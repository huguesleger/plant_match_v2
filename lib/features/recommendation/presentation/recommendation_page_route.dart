import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/recommendation/data/repositories/recommendation_repository_impl.dart';
import 'package:plant_match_v2/features/recommendation/presentation/cubit/recommendation_cubit.dart';
import 'package:plant_match_v2/features/recommendation/presentation/recommendation_screen.dart';

import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';

class RecommendationPageRoute extends StatelessWidget {
  const RecommendationPageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId ?? '';

    return BlocProvider(
      create: (context) => RecommendationCubit(
        repository: RecommendationRepositoryImpl(),
        userId: userId,
      )..startQuestionnaire(),
      child: const RecommendationScreen(),
    );
  }
}
