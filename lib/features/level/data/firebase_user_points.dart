import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/level/utils/user_points_utils.dart';

class FirebaseUserPoints implements UserPointsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  TaskEither<Failure, UserPoints> addPoints(
    String userId,
    int initialPoints,
    int level,
  ) {
    return TaskEither.tryCatch(
      () async {
        await _firestore.collection('userPoints').doc(userId).set({
          'currentPoints': initialPoints,
          'level': level,
        });
        return UserPoints(
          currentPoints: initialPoints,
          level: level,
          uid: userId,
        );
      },
      (error, stackTrace) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, UserPoints> getPoints(String userId) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _firestore.collection('userPoints').doc(userId).get();

        if (!doc.exists) {
          throw NotFoundFailure('Utilisateur $userId non trouvé');
        }

        final data = doc.data();
        if (data == null) {
          throw NotFoundFailure('Données utilisateur $userId vides');
        }

        return UserPoints.fromJson({
          ...data,
          'uid': userId,
        });
      },
      (error, stackTrace) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> updatePoints(String userId, int pointsToAdd) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _firestore.collection('userPoints').doc(userId).get();

        if (!doc.exists) {
          throw NotFoundFailure('Utilisateur $userId non trouvé');
        }

        final data = doc.data();
        if (data == null) {
          throw NotFoundFailure('Données utilisateur $userId vides');
        }

        final userPoints = UserPoints.fromJson({
          ...data,
          'uid': userId,
        });

        int currentPoints = userPoints.currentPoints + pointsToAdd;
        if (currentPoints < 0) currentPoints = 0;

        int level = 1;
        final Map<int, LevelData> reversedLevels = Map.fromEntries(
          UserPointsUtils.levelData.entries.toList().reversed,
        );

        for (final entry in reversedLevels.entries) {
          final l = entry.key;
          final prevLevel = l - 1;
          final prevMaxPoints = prevLevel > 0
              ? UserPointsUtils.getMaxPointsForLevel(prevLevel)
              : 0;

          if (currentPoints >= prevMaxPoints) {
            level = l;
            break;
          }
        }

        await _firestore.collection('userPoints').doc(userId).update({
          'currentPoints': currentPoints,
          'level': level,
        });

        return unit;
      },
      (error, stackTrace) => _mapErrorToFailure(error),
    );
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) {
      return error;
    }

    if (error is FirebaseException) {
      return FirebaseFailure(
        'Erreur Firebase: ${error.message ?? error.code}',
      );
    }

    return UnexpectedFailure('Erreur inattendue: $error');
  }
}
