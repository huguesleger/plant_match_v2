import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';

sealed class LevelAwardedState {}

class LevelAwardedInitial extends LevelAwardedState {}

class LevelAwardedLoading extends LevelAwardedState {}

class LevelAwardedLoaded extends LevelAwardedState {
  final UserPoints userPoints;
  LevelAwardedLoaded(this.userPoints);
}

class LevelAwardedError extends LevelAwardedState {
  final String message;
  LevelAwardedError(this.message);
}
