import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/domain/repositories/recommendation_repository.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const int _maxCandidates = 100;
  static final RegExp _nonToxic = RegExp(r'non[\s-]*toxique');

  static bool _mentionsToxicity(String text) =>
      text.toLowerCase().replaceAll(_nonToxic, '').contains('toxique');

  static Option<String> _environmentFilter(RecommendationAnswers answers) =>
      answers.environment.flatMap(
        (env) => switch (env) {
          IndoorEnv() => Some(Environment.indoor.name),
          OutdoorEnv() => Some(Environment.outdoor.name),
          BothEnv() => const None(),
        },
      );

  static Option<String> _lightingFilter(RecommendationAnswers answers) =>
      answers.light.map(
        (light) => switch (light) {
          LowLight() => Lighting.shade.name,
          IndirectLight() => Lighting.indirectLight.name,
          DirectLight() => Lighting.sun.name,
        },
      );

  static Option<String> _careFilter(RecommendationAnswers answers) =>
      answers.careLevel.map(
        (care) => switch (care) {
          BeginnerCare() => LevelMaintenance.low.name,
          IntermediateCare() => LevelMaintenance.medium.name,
          ExpertCare() => LevelMaintenance.high.name,
        },
      );

  static Query<Map<String, dynamic>> _whereOption(
    Query<Map<String, dynamic>> query,
    String field,
    Option<String> value,
  ) =>
      value.match(() => query, (v) => query.where(field, isEqualTo: v));

  static bool _isPetSafe(Catalog plant, RecommendationAnswers answers) =>
      answers.petSafety.match(
        () => true,
        (safety) => switch (safety) {
          SafeForPets() => !_mentionsToxicity(plant.description) &&
              !_mentionsToxicity(plant.name),
          IndifferentSafety() => true,
        },
      );

  @override
  TaskEither<Failure, List<Catalog>> getRecommendedPlants(
    String userId,
    RecommendationAnswers answers,
  ) =>
      TaskEither.tryCatch(
        () async {
          final filtered = [
            ('environment', _environmentFilter(answers)),
            ('lighting', _lightingFilter(answers)),
            ('levelMaintenance', _careFilter(answers)),
          ].fold<Query<Map<String, dynamic>>>(
            _firestore
                .collection('catalogs')
                .where('status', isEqualTo: CatalogStatus.published.name),
            (query, filter) => _whereOption(query, filter.$1, filter.$2),
          );
          final snapshot = await filtered
              .orderBy('createdAt', descending: true)
              .limit(_maxCandidates)
              .get();
          return snapshot.docs
              .map((doc) => Catalog.fromJson(doc.data(), doc.id))
              .where((plant) => plant.userId != userId)
              .where((plant) => _isPetSafe(plant, answers))
              .toList();
        },
        (error, _) => mapError(error),
      );

  @override
  TaskEither<Failure, Unit> saveAnswers(
    String userId,
    RecommendationAnswers answers,
  ) {
    return TaskEither.tryCatch(
      () async {
        await _firestore.collection('user_recommendations').doc(userId).set({
          'userId': userId,
          'answers': answers.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return unit;
      },
      (error, _) => mapError(error),
    );
  }

  @override
  TaskEither<Failure, Option<RecommendationAnswers>> getSavedAnswers(
    String userId,
  ) {
    return TaskEither.tryCatch(
      () async {
        final doc = await _firestore
            .collection('user_recommendations')
            .doc(userId)
            .get();

        return Option.fromNullable(doc.data())
            .filter((data) => data.containsKey('answers'))
            .map((data) => RecommendationAnswers.fromJson(
                data['answers'] as Map<String, dynamic>));
      },
      (error, _) => mapError(error),
    );
  }
}
