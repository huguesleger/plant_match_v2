import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/user_points/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/user_points/presentation/cubit/user_points_state.dart';

class UserPointsCubit extends Cubit<UserPointsState> {
  final UserPointsRepository repository;

  UserPointsCubit({required this.repository}) : super(UserPointsInitial());

  // ─── fetchUserPoints ───────────────────────────────────────────────────────

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

  // ─── addUserPoints ─────────────────────────────────────────────────────────

  void addUserPoints(
    String userId,
    int initialPoints,
    int level, {
    bool isFromRegistration = false,
  }) {
    emit(UserPointsLoading());

    repository
        .addPoints(userId, initialPoints, level)
        .match(
          (failure) => UserPointsError(failure.message),
          (userPoints) {
            emit(UserPointsAwarded(
              initialPoints,
              userId,
              userPoints,
              isFromRegistration: isFromRegistration,
            ));
            return UserPointsLoaded(
              userPoints.currentPoints,
              userPoints.level,
              userPoints,
            );
          },
        )
        .map(emit)
        .run();
  }

  // ─── updateUserPoints ──────────────────────────────────────────────────────

  void updateUserPoints(String userId, int pointsToAdd) {
    emit(UserPointsLoading());

    repository
        .updatePoints(userId, pointsToAdd)
        .flatMap((_) => repository.getPoints(userId))
        .match(
          (failure) => UserPointsError(failure.message),
          (userPoints) {
            emit(UserPointsAwarded(pointsToAdd, userId, userPoints));
            return UserPointsLoaded(
              userPoints.currentPoints,
              userPoints.level,
              userPoints,
            );
          },
        )
        .map(emit)
        .run();
  }
}
