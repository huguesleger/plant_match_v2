import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';

class PointsUpdate {
  final UserPoints userPoints;
  final int previousLevel;
  final int bonusLeaves;
  final int giftedLeaves;

  const PointsUpdate({
    required this.userPoints,
    required this.previousLevel,
    required this.bonusLeaves,
    required this.giftedLeaves,
  });

  int get totalLeaves => bonusLeaves + giftedLeaves;

  bool get isLevelUp => userPoints.level > previousLevel;
}
