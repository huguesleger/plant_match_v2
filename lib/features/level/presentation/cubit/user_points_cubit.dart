import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/level/presentation/cubit/user_points_state.dart';

class UserPointsCubit extends Cubit<UserPointsState> {
  final UserPointsRepository repository;

  UserPointsCubit({required this.repository}) : super(UserPointsInitial());

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
              isLevelUp: false,
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

  void updateUserPoints(String userId, int pointsToAdd) {
    final oldState = state;
    int oldLevel = 1;
    if (oldState is UserPointsLoaded) {
      oldLevel = oldState.level;
    } else if (oldState is UserPointsAwarded) {
      oldLevel = oldState.userPoints.level;
    }

    emit(UserPointsLoading());

    repository
        .updatePoints(userId, pointsToAdd)
        .flatMap((_) => repository.getPoints(userId))
        .match(
          (failure) => UserPointsError(failure.message),
          (userPoints) {
            final isLevelUp = userPoints.level > oldLevel;
            emit(UserPointsAwarded(
              pointsToAdd,
              userId,
              userPoints,
              isLevelUp: isLevelUp,
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
}
