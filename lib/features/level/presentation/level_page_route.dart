import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/level_screen.dart';

class LevelPageRoute extends StatelessWidget {
  LevelPageRoute({super.key});

  final userPointsRepository = FirebaseUserPoints();

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté")),
      );
    }

    return BlocProvider(
      create: (context) => UserPointsCubit(repository: userPointsRepository)
        ..fetchUserPoints(userId),
      child: LevelScreen(userId: userId),
    );
  }
}
