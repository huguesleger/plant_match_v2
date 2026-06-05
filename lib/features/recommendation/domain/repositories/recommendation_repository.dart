import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';

abstract class RecommendationRepository {
  TaskEither<Failure, List<Catalog>> getRecommendedPlants(
    RecommendationAnswers answers,
  );

  TaskEither<Failure, Unit> saveAnswers(
    String userId,
    RecommendationAnswers answers,
  );

  TaskEither<Failure, Option<RecommendationAnswers>> getSavedAnswers(
    String userId,
  );
}
