import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/domain/entities/points_update.dart';
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
  TaskEither<Failure, PointsUpdate> updatePoints(
    String userId,
    int pointsToAdd, {
    int giftedLeaves = 0,
  }) {
    return TaskEither.tryCatch(
      () => _firestore.runTransaction((transaction) async {
        final pointsRef = _firestore.collection('userPoints').doc(userId);
        final doc = await transaction.get(pointsRef);
        final data = Option.fromNullable(doc.data()).getOrElse(
          () => throw NotFoundFailure('Utilisateur $userId non trouvé'),
        );
        final previous = UserPoints.fromJson({...data, 'uid': userId});
        final updated = UserPointsUtils.updatePoints(previous, pointsToAdd);
        final bonusLeaves =
            UserPointsUtils.bonusLeavesBetween(previous.level, updated.level);

        transaction.update(pointsRef, {
          'currentPoints': updated.currentPoints,
          'level': updated.level,
        });
        transaction.update(
          _firestore.collection('users').doc(userId),
          {'leaves': FieldValue.increment(bonusLeaves + giftedLeaves)},
        );

        return PointsUpdate(
          userPoints: updated,
          previousLevel: previous.level,
          bonusLeaves: bonusLeaves,
          giftedLeaves: giftedLeaves,
        );
      }),
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
