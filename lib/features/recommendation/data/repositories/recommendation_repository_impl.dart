import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/failures/failure.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/domain/repositories/recommendation_repository.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  TaskEither<Failure, List<Catalog>> getRecommendedPlants(
    RecommendationAnswers answers,
  ) {
    return TaskEither.tryCatch(
      () async {
        final querySnapshot = await _firestore
            .collection('catalogs')
            .where('status', isEqualTo: 'published')
            .get();

        final allPlants = querySnapshot.docs
            .map((doc) => Catalog.fromJson(doc.data(), doc.id))
            .toList();

        return allPlants.where((plant) {
          final matchEnv = answers.environment.match(
            () => true,
            (env) => switch (env) {
              IndoorEnv() => plant.environment == Environment.indoor,
              OutdoorEnv() => plant.environment == Environment.outdoor,
              BothEnv() => true,
            },
          );
          if (!matchEnv) return false;

          final matchLight = answers.light.match(
            () => true,
            (light) => switch (light) {
              LowLight() => plant.lighting == Lighting.shade,
              IndirectLight() => plant.lighting == Lighting.indirectLight,
              DirectLight() => plant.lighting == Lighting.sun,
            },
          );
          if (!matchLight) return false;

          final matchCare = answers.careLevel.match(
            () => true,
            (care) => switch (care) {
              BeginnerCare() => plant.levelMaintenance == LevelMaintenance.low,
              IntermediateCare() =>
                plant.levelMaintenance == LevelMaintenance.medium,
              ExpertCare() => plant.levelMaintenance == LevelMaintenance.high,
            },
          );
          if (!matchCare) return false;

          final matchSafety = answers.petSafety.match(
            () => true,
            (safety) => switch (safety) {
              SafeForPets() =>
                !plant.description.toLowerCase().contains('toxique') &&
                    !plant.name.toLowerCase().contains('toxique'),
              IndifferentSafety() => true,
            },
          );
          if (!matchSafety) return false;

          return true;
        }).toList();
      },
      (error, stackTrace) => FirebaseFailure(
        'Erreur lors du calcul des recommandations : $error',
      ),
    );
  }

  @override
  TaskEither<Failure, Unit> saveAnswers(
    String userId,
    RecommendationAnswers answers,
  ) {
    return TaskEither.tryCatch(
      () async {
        await _firestore
            .collection('user_recommendations')
            .doc(userId)
            .set({
          'userId': userId,
          'answers': answers.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return unit;
      },
      (error, stackTrace) => FirebaseFailure(
        'Erreur lors de la sauvegarde des recommandations : $error',
      ),
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

        final data = doc.data();
        if (data == null || !data.containsKey('answers')) {
          return none();
        }

        final answersMap = data['answers'] as Map<String, dynamic>;
        return some(RecommendationAnswers.fromJson(answersMap));
      },
      (error, stackTrace) => FirebaseFailure(
        'Erreur lors de la récupération des recommandations sauvegardées : $error',
      ),
    );
  }
}
