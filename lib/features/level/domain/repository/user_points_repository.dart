import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/level/domain/entities/user_points.dart';
import 'package:plant_match_v2/core/failures/failure.dart';

abstract class UserPointsRepository {
  TaskEither<Failure, UserPoints> addPoints(
    String userId,
    int initialPoints,
    int level,
  );

  TaskEither<Failure, Unit> updatePoints(
    String userId,
    int pointsToAdd,
  );

  TaskEither<Failure, UserPoints> getPoints(String userId);
}
