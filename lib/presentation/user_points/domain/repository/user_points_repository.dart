import 'package:plant_match_v2/presentation/user_points/data/firebase_user_points.dart';
import 'package:plant_match_v2/presentation/user_points/domain/entities/user_points.dart';
import 'package:plant_match_v2/presentation/user_points/presentation/utils/user_points_utils.dart';

class UserPointsRepository {
  final FirebaseUserPoints _firebaseUserPoints = FirebaseUserPoints();

  Future<UserPoints> addPoints(
      String userId, int currentPoints, int level) async {
    try {
      await _firebaseUserPoints.addPoints(userId, currentPoints, level);
      return UserPoints(
        uid: userId,
        currentPoints: currentPoints,
        level: level,
      );
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout des points : $e');
    }
  }

  Future<void> updatePoints(String userId, int pointsToAdd) async {
    try {
      final userData = await _firebaseUserPoints.getPoints(userId);
      int currentPoints = userData.currentPoints;
      int level = userData.level;

      // Ajoutez les points et ajustez le niveau
      currentPoints += pointsToAdd;
      while (currentPoints >= UserPointsUtils.getMaxPointsForLevel(level)) {
        currentPoints -= UserPointsUtils.getMaxPointsForLevel(level);
        level++;
      }

      await _firebaseUserPoints.updatePoints(userId, pointsToAdd);
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour des points : $e');
    }
  }

  Future<UserPoints> getPoints(String userId) async {
    try {
      final userData = await _firebaseUserPoints.getPoints(userId);
      return UserPoints(
        uid: userId,
        currentPoints: userData.currentPoints,
        level: userData.level,
      );
    } catch (e) {
      throw Exception('Erreur lors de la récupération des points : $e');
    }
  }
}
