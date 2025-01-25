import 'package:plant_match_v2/presentation/user_points/domain/entities/user_points.dart';

class UserPointsUtils {
  static const Map<int, int> levelPoints = {
    1: 50,
    2: 150,
    3: 400,
    4: 800,
    5: 1500,
    6: 3000,
    7: 6000,
  };

  static int getMaxPointsForLevel(int level) {
    return levelPoints[level] ?? 0;
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

    // Vérification pour le passage au niveau supérieur
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
