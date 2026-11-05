import 'package:plant_match_v2/core/util/json_reader.dart';
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

  factory PointsUpdate.fromJson(Map<String, dynamic> json) => PointsUpdate(
        userPoints: UserPoints(
          uid: json.string('uid'),
          currentPoints: json.integer('currentPoints'),
          level: json.integer('level', 1),
        ),
        previousLevel: json.integer('previousLevel', 1),
        bonusLeaves: json.integer('bonusLeaves'),
        giftedLeaves: json.integer('giftedLeaves'),
      );

  bool get isLevelUp => userPoints.level > previousLevel;
}
