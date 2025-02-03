import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plant_match_v2/presentation/user_points/domain/entities/user_points.dart';
import 'package:plant_match_v2/presentation/user_points/domain/repository/user_points_repository.dart';

class FirebaseUserPoints implements UserPointsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserPoints> addPoints(
      String userId, int initialPoints, int level) async {
    try {
      await _firestore.collection('userPoints').doc(userId).set({
        'currentPoints': initialPoints,
        'level': level,
      });
      return UserPoints(
          currentPoints: initialPoints, level: level, uid: userId);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<UserPoints> getPoints(String userId) async {
    try {
      final userData =
          await _firestore.collection('userPoints').doc(userId).get();
      return UserPoints(
        uid: userId,
        currentPoints: userData['currentPoints'] as int,
        level: userData['level'] as int,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updatePoints(String userId, int pointsToAdd) async {
    try {
      final userData =
          await _firestore.collection('userPoints').doc(userId).get();
      int currentPoints = userData['currentPoints'] as int;
      int level = userData['level'] as int;

      await _firestore.collection('userPoints').doc(userId).update({
        'currentPoints': currentPoints,
        'level': level,
      });
    } catch (e) {
      throw Exception(e);
    }
  }
}
