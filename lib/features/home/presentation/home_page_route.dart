import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/cubit/around_me_cubit.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/cubit/home_cubit.dart';
import 'package:plant_match_v2/features/home/presentation/home_screen.dart';
import 'package:plant_match_v2/features/home/presentation/widgets/home_sync.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/recommendation/data/repositories/recommendation_repository_impl.dart';

class HomePageRoute extends StatelessWidget {
  const HomePageRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthCubit>().userId.getOrElse(() => '');

    return BlocProvider(
      create: (context) => HomeCubit(
        recommendationRepository: RecommendationRepositoryImpl(),
        userId: uid,
      )
        ..syncAroundMe(context.read<AroundMeCubit>().state)
        ..syncProfil(context.read<ProfilCubit>().state)
        ..loadRecommendations(),
      child: HomeSync(child: HomeScreen(uid: uid)),
    );
  }
}
