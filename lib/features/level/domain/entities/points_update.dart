import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';

class PointsUpdate {
  final UserPoints userPoints;
  final int previousLevel;
  final int bonusLeaves;

  const PointsUpdate({
    required this.userPoints,
    required this.previousLevel,
    required this.bonusLeaves,
  });

  bool get isLevelUp => userPoints.level > previousLevel;
}
