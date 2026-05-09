import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';

class UserPointsUtils {
  static Map<int, LevelData> get levelData => {
        1: LevelData(
          maxPoints: 50,
          name: t.level.levels.names.k1,
          icon: LucideIcons.sprout,
        ),
        2: LevelData(
          maxPoints: 150,
          name: t.level.levels.names.k2,
          icon: LucideIcons.leaf,
        ),
        3: LevelData(
          maxPoints: 400,
          name: t.level.levels.names.k3,
          icon: LucideIcons.wheat,
        ),
        4: LevelData(
          maxPoints: 800,
          name: t.level.levels.names.k4,
          icon: LucideIcons.shovel,
        ),
        5: LevelData(
          maxPoints: 1500,
          name: t.level.levels.names.k5,
          icon: LucideIcons.flower,
        ),
        6: LevelData(
          maxPoints: 3000,
          name: t.level.levels.names.k6,
          icon: LucideIcons.tree_pine,
        ),
        7: LevelData(
          maxPoints: 6000,
          name: t.level.levels.names.k7,
          icon: LucideIcons.trees,
        ),
      };

  static LevelData get defaultLevel => LevelData(
        maxPoints: 50,
        name: t.level.levels.names.k1,
        icon: LucideIcons.sprout,
      );

  static int getMaxPointsForLevel(int level) {
    return levelData[level]?.maxPoints ?? defaultLevel.maxPoints;
  }

  static IconData getIconForLevel(int level) {
    return levelData[level]?.icon ?? defaultLevel.icon;
  }

  static String getLevelName(int level) {
    return levelData[level]?.name ?? defaultLevel.name;
  }

  static int? getNextLevel(int currentLevel) {
    if (levelData.containsKey(currentLevel + 1)) {
      return currentLevel + 1;
    }
    return null;
  }

  static double calculateLevelProgression(UserPoints userPoints) {
    final currentLevel = userPoints.level;
    final nextLevel = getNextLevel(currentLevel);

    if (nextLevel == null) {
      return 1.0;
    }

    final currentLevelMaxPoints = getMaxPointsForLevel(currentLevel);
    final pointsInCurrentLevel = userPoints.currentPoints;

    if (currentLevelMaxPoints > 0) {
      return pointsInCurrentLevel / currentLevelMaxPoints;
    }

    return 0.0;
  }

  static double calculateProgress(UserPoints userPoints) {
    final maxPoints = getMaxPointsForLevel(userPoints.level);
    if (maxPoints == 0) return 0;
    return userPoints.currentPoints / maxPoints;
  }

  static UserPoints updatePoints(UserPoints userPoints, int pointsToAdd) {
    int newPoints = userPoints.currentPoints + pointsToAdd;
    if (newPoints < 0) newPoints = 0;

    int newLevel = 1;
    final Map<int, LevelData> reversedLevels = Map.fromEntries(
      levelData.entries.toList().reversed,
    );

    for (final entry in reversedLevels.entries) {
      final level = entry.key;
      final prevLevel = level - 1;
      final prevMaxPoints =
          prevLevel > 0 ? getMaxPointsForLevel(prevLevel) : 0;

      if (newPoints >= prevMaxPoints) {
        newLevel = level;
        break;
      }
    }

    return UserPoints(
      uid: userPoints.uid,
      currentPoints: newPoints,
      level: newLevel,
    );
  }
}

class LevelData {
  final int maxPoints;
  final String name;
  final IconData icon;

  const LevelData({
    required this.maxPoints,
    required this.name,
    required this.icon,
  });
}
