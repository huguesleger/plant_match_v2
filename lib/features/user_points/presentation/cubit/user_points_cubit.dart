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
        .map((userPoints) => emit(UserPointsLoaded(
              userPoints.currentPoints,
              userPoints.level,
              userPoints,
            )))
        .run()
        .then((result) => result.match(
              (failure) => emit(UserPointsError(failure.message)),
              (_) => null,
            ));
  }

  // ─── addUserPoints ─────────────────────────────────────────────────────────

  void addUserPoints(
    String userId,
    int initialPoints,
    int level,
  ) {
    emit(UserPointsLoading());

    repository
        .addPoints(userId, initialPoints, level)
        .map((userPoints) => emit(UserPointsLoaded(
              userPoints.currentPoints,
              userPoints.level,
              userPoints,
            )))
        .run()
        .then((result) => result.match(
              (failure) => emit(UserPointsError(failure.message)),
              (_) => null,
            ));
  }

  // ─── updateUserPoints ──────────────────────────────────────────────────────

  void updateUserPoints(String userId, int pointsToAdd) {
    emit(UserPointsLoading());

    repository
        .updatePoints(userId, pointsToAdd)
        .flatMap((_) => repository.getPoints(userId))
        .map((userPoints) => emit(UserPointsLoaded(
              userPoints.currentPoints,
              userPoints.level,
              userPoints,
            )))
        .run()
        .then((result) => result.match(
              (failure) => emit(UserPointsError(failure.message)),
              (_) => null,
            ));
  }
}
