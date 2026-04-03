import 'package:plant_match_v2/features/user_points/domain/entities/user_points.dart';

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
  final String message;

  UserPointsError(this.message);
}

class UserPointsAwarded extends UserPointsState {
  final int points;
  final String userId;
  final UserPoints userPoints;
  final bool isFromRegistration;

  UserPointsAwarded(this.points, this.userId, this.userPoints,
      {this.isFromRegistration = false});
}
