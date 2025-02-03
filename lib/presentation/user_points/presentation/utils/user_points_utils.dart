import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_match_v2/presentation/user_points/domain/entities/user_points.dart';

class UserPointsUtils {
  static const Map<int, LevelData> levelData = {
    1: LevelData(
      maxPoints: 50,
      name: 'Novice des plantes',
      icon: LucideIcons.sprout,
    ),
    2: LevelData(
      maxPoints: 150,
      name: 'Amoureux des feuilles',
      icon: LucideIcons.leaf,
    ),
    3: LevelData(
      maxPoints: 400,
      name: 'Cultivateur actif',
      icon: LucideIcons.wheat,
    ),
    4: LevelData(
      maxPoints: 800,
      name: 'Jardinier confirmer',
      icon: LucideIcons.shovel,
    ),
    5: LevelData(
      maxPoints: 1500,
      name: 'Expert des plantes',
      icon: LucideIcons.flower,
    ),
    6: LevelData(
      maxPoints: 3000,
      name: 'Maître jardinier',
      icon: LucideIcons.tractor,
    ),
    7: LevelData(
      maxPoints: 6000,
      name: 'Gardien de la nature',
      icon: LucideIcons.trees,
    ),
  };

  static const LevelData defaultLevel = LevelData(
    maxPoints: 50,
    name: 'Novice des plantes',
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

  /// Calculer la progression (pour le LinearProgressIndicator)
  static double calculateProgress(UserPoints userPoints) {
    final maxPoints = getMaxPointsForLevel(userPoints.level);
    if (maxPoints == 0) return 0;
    return userPoints.currentPoints / maxPoints;
  }

  /// Mettre à jour les points et calculer le niveau
  static UserPoints updatePoints(UserPoints userPoints, int pointsToAdd) {
    int newPoints = userPoints.currentPoints + pointsToAdd;
    int newLevel = userPoints.level;

    while (newPoints >= getMaxPointsForLevel(newLevel)) {
      newPoints -= getMaxPointsForLevel(newLevel);
      newLevel++;
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
