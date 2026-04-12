import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/level/data/firebase_user_points.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/cubit/level_awarded_cubit.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/level_awarded_screen.dart';

class LevelAwardedPageRoute extends StatelessWidget {
  const LevelAwardedPageRoute({
    super.key,
    required this.userId,
    required this.userPoints,
    this.isFromRegistration = false,
  });

  final String userId;
  final UserPoints userPoints;
  final bool isFromRegistration;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LevelAwardedCubit(
        userPointsRepository: FirebaseUserPoints(),
      )..load(userId),
      child: LevelAwardedScreen(
        userId: userId,
        userPoints: userPoints,
        isFromRegistration: isFromRegistration,
      ),
    );
  }
}
