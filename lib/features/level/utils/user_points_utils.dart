import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';

class UserPointsUtils {
  static const int maxLevel = 7;

  static Map<int, LevelData> get levelData => {
        1: LevelData(
          maxPoints: 2,
          bonusLeaves: 5,
          name: t.level.levels.names.k1,
          icon: LucideIcons.sprout,
        ),
        2: LevelData(
          maxPoints: 5,
          bonusLeaves: 3,
          name: t.level.levels.names.k2,
          icon: LucideIcons.leaf,
        ),
        3: LevelData(
          maxPoints: 10,
          bonusLeaves: 5,
          name: t.level.levels.names.k3,
          icon: LucideIcons.wheat,
        ),
        4: LevelData(
          maxPoints: 25,
          bonusLeaves: 8,
          name: t.level.levels.names.k4,
          icon: LucideIcons.shovel,
        ),
        5: LevelData(
          maxPoints: 50,
          bonusLeaves: 12,
          name: t.level.levels.names.k5,
          icon: LucideIcons.flower,
        ),
        6: LevelData(
          maxPoints: 100,
          bonusLeaves: 20,
          name: t.level.levels.names.k6,
          icon: LucideIcons.tree_pine,
        ),
        7: LevelData(
          maxPoints: 100,
          bonusLeaves: 0,
          name: t.level.levels.names.k7,
          icon: LucideIcons.trees,
        ),
      };

  static LevelData get defaultLevel => LevelData(
        maxPoints: 2,
        bonusLeaves: 5,
        name: t.level.levels.names.k1,
        icon: LucideIcons.sprout,
      );

  static LevelData _dataFor(int level) =>
      Option.fromNullable(levelData[level]).getOrElse(() => defaultLevel);

  static int getMaxPointsForLevel(int level) => _dataFor(level).maxPoints;

  static IconData getIconForLevel(int level) => _dataFor(level).icon;

  static String getLevelName(int level) => _dataFor(level).name;

  static Option<int> getNextLevel(int currentLevel) =>
      levelData.containsKey(currentLevel + 1)
          ? Some(currentLevel + 1)
          : const None();

  static int getBonusLeavesForLevel(int level) =>
      levelData.containsKey(level) ? _dataFor(level).bonusLeaves : 0;

  static int bonusLeavesBetween(int fromLevel, int toLevel) => List.generate(
        (toLevel - fromLevel).clamp(0, maxLevel),
        (index) => getBonusLeavesForLevel(fromLevel + index + 1),
      ).fold(0, (sum, bonus) => sum + bonus);

  static bool hasUnlimitedContacts(int level) => level >= maxLevel;

  static int requiredPointsFor(int level) =>
      level > 1 ? getMaxPointsForLevel(level - 1) : 0;

  static int levelForPoints(int points) => levelData.keys
      .where((level) => points >= requiredPointsFor(level))
      .fold(1, (best, level) => level > best ? level : best);

  static double calculateLevelProgression(UserPoints userPoints) {
    final previousMax = requiredPointsFor(userPoints.level);
    final range = getMaxPointsForLevel(userPoints.level) - previousMax;
    return switch ((userPoints.level >= maxLevel, range > 0)) {
      (true, _) => 1.0,
      (false, false) => 0.0,
      (false, true) =>
        ((userPoints.currentPoints - previousMax) / range).clamp(0.0, 1.0),
    };
  }

  static double calculateProgress(UserPoints userPoints) =>
      calculateLevelProgression(userPoints);

  static UserPoints updatePoints(UserPoints userPoints, int pointsToAdd) {
    final newPoints = max(0, userPoints.currentPoints + pointsToAdd);
    return UserPoints(
      uid: userPoints.uid,
      currentPoints: newPoints,
      level: levelForPoints(newPoints),
    );
  }
}

class LevelData {
  final int maxPoints;
  final int bonusLeaves;
  final String name;
  final IconData icon;

  const LevelData({
    required this.maxPoints,
    required this.bonusLeaves,
    required this.name,
    required this.icon,
  });
}
