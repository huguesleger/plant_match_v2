import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_cubit.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';
import 'package:plant_match_v2/features/level_awarded/presentation/show_level_awarded.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_cubit.dart';
import 'package:plant_match_v2/features/profil/presentation/cubit/profil_state.dart';

class RewardListener extends StatelessWidget {
  const RewardListener({super.key, required this.child});

  final Widget child;

  Future<Unit> _show(
    BuildContext context, {
    required int leaves,
    required String title,
    required String description,
  }) =>
      showLevelAwarded(
        Navigator.of(context),
        leaves: leaves,
        title: title,
        description: description,
      );

  void _onProfil(BuildContext context, ProfilState state) => switch (state) {
        ProfilLoaded(:final leavesGained, :final rewardMessage)
            when leavesGained > 0 =>
          _show(
            context,
            leaves: leavesGained,
            title: rewardMessage
                .getOrElse(() => t.levelAwarded.rewards.default_title),
            description: t.levelAwarded.rewards.default_description,
          ),
        ProfilLoaded() ||
        ProfilInitial() ||
        ProfilLoading() ||
        ProfilError() ||
        ProfilImageUploading() =>
          Future<Unit>.value(unit),
      };

  Future<Unit> _celebrateLevelUp(BuildContext context, PointsUpdate update) {
    context.read<ProfilCubit>().refreshLeaves(update.userPoints.uid);
    return _show(
      context,
      leaves: update.totalLeaves,
      title:
          t.levelAwarded.rewards.level_up_title(level: update.userPoints.level),
      description: t.levelAwarded.rewards.level_up_description(
        name: UserPointsUtils.getLevelName(update.userPoints.level),
      ),
    );
  }

  Future<Unit> _celebratePlantGiven(
    BuildContext context,
    PointsUpdate update,
  ) {
    context.read<ProfilCubit>().refreshLeaves(update.userPoints.uid);
    return _show(
      context,
      leaves: update.giftedLeaves,
      title: t.levelAwarded.rewards.plant_given,
      description: t.levelAwarded.rewards.plant_given_description,
    );
  }

  void _onPoints(BuildContext context, UserPointsState state) =>
      switch (state) {
        UserPointsAwarded(:final update) when update.isLevelUp =>
          _celebrateLevelUp(context, update),
        UserPointsAwarded(:final update) when update.giftedLeaves > 0 =>
          _celebratePlantGiven(context, update),
        UserPointsAwarded() ||
        UserPointsInitial() ||
        UserPointsLoading() ||
        UserPointsLoaded() ||
        UserPointsError() =>
          Future<Unit>.value(unit),
      };

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfilCubit, ProfilState>(listener: _onProfil),
        BlocListener<UserPointsCubit, UserPointsState>(listener: _onPoints),
      ],
      child: child,
    );
  }
}
