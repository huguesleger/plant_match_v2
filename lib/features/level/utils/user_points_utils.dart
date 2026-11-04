import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';

class UserPointsUtils {
  static Map<int, LevelData> get levelData => {
        1: LevelData(
          maxPoints: 2,
          name: t.level.levels.names.k1,
          icon: LucideIcons.sprout,
        ),
        2: LevelData(
          maxPoints: 5,
          name: t.level.levels.names.k2,
          icon: LucideIcons.leaf,
        ),
        3: LevelData(
          maxPoints: 10,
          name: t.level.levels.names.k3,
          icon: LucideIcons.wheat,
        ),
        4: LevelData(
          maxPoints: 25,
          name: t.level.levels.names.k4,
          icon: LucideIcons.shovel,
        ),
        5: LevelData(
          maxPoints: 50,
          name: t.level.levels.names.k5,
          icon: LucideIcons.flower,
        ),
        6: LevelData(
          maxPoints: 100,
          name: t.level.levels.names.k6,
          icon: LucideIcons.tree_pine,
        ),
        7: LevelData(
          maxPoints: 100,
          name: t.level.levels.names.k7,
          icon: LucideIcons.trees,
        ),
      };

  static LevelData get defaultLevel => LevelData(
        maxPoints: 2,
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

  static int getBonusLeavesForLevel(int level) => switch (level) {
        1 => 5,
        2 => 3,
        3 => 5,
        4 => 8,
        5 => 12,
        6 => 20,
        7 => 9999, // Représente les feuilles illimitées
        _ => 0,
      };

  static double calculateLevelProgression(UserPoints userPoints) {
    final currentLevel = userPoints.level;
    if (currentLevel >= 7) {
      return 1.0;
    }

    final prevMaxPoints =
        currentLevel > 1 ? getMaxPointsForLevel(currentLevel - 1) : 0;
    final currentLevelMaxPoints = getMaxPointsForLevel(currentLevel);
    final range = currentLevelMaxPoints - prevMaxPoints;

    if (range <= 0) return 0.0;

    final progressInLevel = userPoints.currentPoints - prevMaxPoints;
    return (progressInLevel / range).clamp(0.0, 1.0);
  }

  static double calculateProgress(UserPoints userPoints) {
    return calculateLevelProgression(userPoints);
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

