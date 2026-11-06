import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
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
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, UserPoints> getPoints(String userId) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _firestore.collection('userPoints').doc(userId).get();

        if (!doc.exists) {
          throw const NotFoundFailure('User points not found');
        }

        final data = Option.fromNullable(doc.data()).getOrElse(
          () => throw const NotFoundFailure('User points empty'),
        );

        return UserPoints.fromJson({
          ...data,
          'uid': userId,
        });
      },
      (error, _) => mapError(error),
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
          (error, _) => mapError(error),
        ),
      )
      .transform(
        StreamTransformer.fromHandlers(
          handleError: (error, _, sink) =>
              sink.add(Left(mapError(error))),
        ),
      );

  UserPoints _fromData(String userId, Option<Map<String, dynamic>> data) =>
      UserPoints.fromJson({
        'currentPoints': 0,
        'level': 1,
        ...data.getOrElse(() => {}),
        'uid': userId,
      });
}
