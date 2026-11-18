import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_location.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_score.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/scored_plant.dart';

class RecommendationResults {
  final List<ScoredPlant> matches;
  final List<ScoredPlant> alternatives;

  const RecommendationResults({
    required this.matches,
    required this.alternatives,
  });

  static const int _maxAlternatives = 10;

  factory RecommendationResults.from({
    required List<Catalog> plants,
    required RecommendationAnswers answers,
    required Option<RecommendationLocation> location,
    required DateTime now,
  }) =>
      _split(
        plants
            .map((plant) => RecommendationScore.score(
                  plant,
                  answers,
                  location.flatMap((l) => l.distanceTo(plant.userId)),
                  now,
                ))
            .toList()
          ..sort(_byRelevance),
      );

  factory RecommendationResults.boneMock() => RecommendationResults(
        matches: List.generate(3, (_) => ScoredPlant.boneMock()),
        alternatives: const [],
      );

  bool get isEmpty => matches.isEmpty && alternatives.isEmpty;

  static RecommendationResults _split(List<ScoredPlant> ranked) =>
      RecommendationResults(
        matches: ranked
            .where((p) => p.score >= RecommendationScore.matchThreshold)
            .toList(),
        alternatives: ranked
            .where((p) =>
                p.score < RecommendationScore.matchThreshold &&
                p.score >= RecommendationScore.alternativeThreshold)
            .take(_maxAlternatives)
            .toList(),
      );

  static int _byRelevance(ScoredPlant a, ScoredPlant b) => a.score != b.score
      ? b.score.compareTo(a.score)
      : b.plant.createdAt.compareTo(a.plant.createdAt);
}
