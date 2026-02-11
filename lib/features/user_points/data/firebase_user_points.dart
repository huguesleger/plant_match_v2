import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/user_points/domain/entities/user_points.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/user_points/domain/repository/user_points_repository.dart';
import 'package:plant_match_v2/features/user_points/presentation/utils/user_points_utils.dart';

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

        return UserPoints(
          uid: userId,
          currentPoints: data['currentPoints'] as int,
          level: data['level'] as int,
        );
      },
      (error, stackTrace) => _mapErrorToFailure(error),
    );
  }

  @override
  TaskEither<Failure, Unit> updatePoints(String userId, int pointsToAdd) {
    return TaskEither.tryCatch(
      () async {
        // Récupérer les données actuelles
        final doc = await _firestore.collection('userPoints').doc(userId).get();

        if (!doc.exists) {
          throw NotFoundFailure('Utilisateur $userId non trouvé');
        }

        final data = doc.data();
        if (data == null) {
          throw NotFoundFailure('Données utilisateur $userId vides');
        }

        int currentPoints = data['currentPoints'] as int;
        int level = data['level'] as int;

        // Calculer les nouveaux points et niveau
        currentPoints += pointsToAdd;
        while (currentPoints >= UserPointsUtils.getMaxPointsForLevel(level)) {
          currentPoints -= UserPointsUtils.getMaxPointsForLevel(level);
          level++;
        }

        // Mettre à jour dans Firebase
        await _firestore.collection('userPoints').doc(userId).update({
          'currentPoints': currentPoints,
          'level': level,
        });

        return unit;
      },
      (error, stackTrace) => _mapErrorToFailure(error),
    );
  }

  /// Mappe les erreurs vers les types Failure appropriés
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
