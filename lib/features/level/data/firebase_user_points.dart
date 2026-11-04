import 'dart:async';

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
        final previous = _fromData(userId, doc.data());
        final updated = UserPointsUtils.updatePoints(previous, pointsToAdd);
        final bonusLeaves =
            UserPointsUtils.bonusLeavesBetween(previous.level, updated.level);

        transaction.set(
          pointsRef,
          {
            'currentPoints': updated.currentPoints,
            'level': updated.level,
          },
          SetOptions(merge: true),
        );
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

  @override
  Stream<Either<Failure, UserPoints>> watchPoints(String userId) => _firestore
      .collection('userPoints')
      .doc(userId)
      .snapshots()
      .map<Either<Failure, UserPoints>>(
        (snapshot) => Either.tryCatch(
          () => _fromData(userId, snapshot.data()),
          (error, _) => _mapErrorToFailure(error),
        ),
      )
      .transform(
        StreamTransformer.fromHandlers(
          handleError: (error, _, sink) =>
              sink.add(Left(_mapErrorToFailure(error))),
        ),
      );

  UserPoints _fromData(String userId, Map<String, dynamic>? data) =>
      UserPoints.fromJson({
        'currentPoints': 0,
        'level': 1,
        ...Option.fromNullable(data).getOrElse(() => {}),
        'uid': userId,
      });

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
