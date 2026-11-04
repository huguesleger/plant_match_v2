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
          uid: json['uid'] as String? ?? '',
          currentPoints: json['currentPoints'] as int? ?? 0,
          level: json['level'] as int? ?? 1,
        ),
        previousLevel: json['previousLevel'] as int? ?? 1,
        bonusLeaves: json['bonusLeaves'] as int? ?? 0,
        giftedLeaves: json['giftedLeaves'] as int? ?? 0,
      );

  bool get isLevelUp => userPoints.level > previousLevel;
}
