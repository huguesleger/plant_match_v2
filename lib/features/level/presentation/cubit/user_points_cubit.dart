import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';

class UserPointsCubit extends Cubit<UserPointsState> {
  final UserPointsRepository repository;

  UserPointsCubit({required this.repository}) : super(UserPointsInitial());

  int get currentLevel => switch (state) {
        UserPointsLoaded(:final level) => level,
        UserPointsAwarded(:final userPoints) => userPoints.level,
        UserPointsInitial() || UserPointsLoading() || UserPointsError() => 1,
      };

  void fetchUserPoints(String userId) {
    emit(UserPointsLoading());

    repository
        .getPoints(userId)
        .match(
          (failure) => UserPointsError(failure.message),
          (userPoints) => UserPointsLoaded(
            userPoints.currentPoints,
            userPoints.level,
            userPoints,
          ),
        )
        .map(emit)
        .run();
  }

  void addUserPoints(String userId, int initialPoints, int level) {
    emit(UserPointsLoading());

    repository
        .addPoints(userId, initialPoints, level)
        .match(
          (failure) => UserPointsError(failure.message),
          (userPoints) => UserPointsLoaded(
            userPoints.currentPoints,
            userPoints.level,
            userPoints,
          ),
        )
        .map(emit)
        .run();
  }

  void updateUserPoints(String userId, int pointsToAdd) {
    repository
        .updatePoints(userId, pointsToAdd)
        .match(
          (failure) => UserPointsError(failure.message),
          UserPointsAwarded.new,
        )
        .map(emit)
        .run();
  }

  Task<Unit> rewardPartner(String userId, int pointsToAdd) => repository
      .updatePoints(userId, pointsToAdd)
      .match((_) => unit, (_) => unit);
}
