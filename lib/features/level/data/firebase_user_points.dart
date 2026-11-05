import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/level/domain/repository/user_points_repository.dart';

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

        final data = Option.fromNullable(doc.data()).getOrElse(
          () => throw NotFoundFailure('Données utilisateur $userId vides'),
        );

        return UserPoints.fromJson({
          ...data,
          'uid': userId,
        });
      },
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
          () => _fromData(userId, Option.fromNullable(snapshot.data())),
          (error, _) => _mapErrorToFailure(error),
        ),
      )
      .transform(
        StreamTransformer.fromHandlers(
          handleError: (error, _, sink) =>
              sink.add(Left(_mapErrorToFailure(error))),
        ),
      );

  UserPoints _fromData(String userId, Option<Map<String, dynamic>> data) =>
      UserPoints.fromJson({
        'currentPoints': 0,
        'level': 1,
        ...data.getOrElse(() => {}),
        'uid': userId,
      });

  Failure _mapErrorToFailure(Object error) {
    if (error is Failure) {
      return error;
    }

    if (error is FirebaseException) {
      return FirebaseFailure(
        'Erreur Firebase: ${Option.fromNullable(error.message).getOrElse(() => error.code)}',
      );
    }

    return UnexpectedFailure('Erreur inattendue: $error');
  }
}
