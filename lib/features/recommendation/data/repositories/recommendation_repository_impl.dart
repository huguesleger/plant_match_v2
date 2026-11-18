import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/core/failures/failure_mapper.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/domain/repositories/recommendation_repository.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const int _maxCandidates = 200;
  static final RegExp _nonToxic = RegExp(r'non[\s-]*toxique');

  static bool _mentionsToxicity(String text) =>
      text.toLowerCase().replaceAll(_nonToxic, '').contains('toxique');

  static bool _isPetSafe(Catalog plant, RecommendationAnswers answers) =>
      answers.petSafety.match(
        () => true,
        (safety) => switch (safety) {
          SafeForPets() => switch (plant.petToxicity) {
              PetSafe() => true,
              PetToxic() => false,
              PetToxicityUnknown() => !_mentionsToxicity(plant.description) &&
                  !_mentionsToxicity(plant.name),
            },
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
          final snapshot = await _firestore
              .collection('catalogs')
              .where('status', isEqualTo: CatalogStatus.published.name)
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
