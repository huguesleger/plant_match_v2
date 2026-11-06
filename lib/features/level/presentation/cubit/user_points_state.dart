import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';

sealed class UserPointsState {}

class UserPointsInitial extends UserPointsState {}

class UserPointsLoading extends UserPointsState {}

class UserPointsLoaded extends UserPointsState {
  final int currentPoints;
  final int level;
  final UserPoints userPoints;

  UserPointsLoaded(this.currentPoints, this.level, this.userPoints);
}

class UserPointsError extends UserPointsState {
  final Failure failure;

  UserPointsError(this.failure);
}

class UserPointsAwarded extends UserPointsState {
  final PointsUpdate update;

  UserPointsAwarded(this.update);

  UserPoints get userPoints => update.userPoints;
}
