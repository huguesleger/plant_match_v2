import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/recommendation_answers.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/scored_plant.dart';

typedef _Criterion = (int, Option<MatchReason>);

class RecommendationScore {
  const RecommendationScore._();

  static const int matchThreshold = 60;
  static const int alternativeThreshold = 40;

  static const int _environmentPoints = 30;
  static const int _versatileEnvironmentPoints = 20;
  static const int _lightPoints = 25;
  static const int _nearLightPoints = 10;
  static const int _carePoints = 20;
  static const int _proximityPoints = 15;
  static const double _proximityRangeKm = 50;
  static const int _verifiedPetSafePoints = 5;
  static const int _maxScore = 100;

  static ScoredPlant score(
    Catalog plant,
    RecommendationAnswers answers,
    Option<double> distanceKm,
    DateTime now,
  ) =>
      _toScoredPlant(plant, [
        _environment(plant.environment, answers.environment),
        _light(plant.lighting, answers.light),
        _care(plant.levelMaintenance, answers.careLevel),
        _proximity(distanceKm),
        _petSafety(plant.petToxicity, answers.petSafety),
        (_freshness(plant.createdAt, now), const None()),
        (_popularity(plant.views), const None()),
      ]);

  static ScoredPlant _toScoredPlant(Catalog plant, List<_Criterion> criteria) =>
      ScoredPlant(
        plant: plant,
        score: criteria
            .fold(0, (total, criterion) => total + criterion.$1)
            .clamp(0, _maxScore),
        reasons: criteria
            .expand((criterion) => criterion.$2.match(
                  () => const <MatchReason>[],
                  (reason) => [reason],
                ))
            .toList(),
      );

  static _Criterion _environment(
    Environment plantEnvironment,
    Option<EnvironmentType> wanted,
  ) =>
      wanted.match(
        () => (_environmentPoints, const None()),
        (environment) => switch (environment) {
          IndoorEnv() =>
            _exactEnvironment(plantEnvironment, Environment.indoor),
          OutdoorEnv() =>
            _exactEnvironment(plantEnvironment, Environment.outdoor),
          BothEnv() => (_versatileEnvironmentPoints, const None()),
        },
      );

  static _Criterion _exactEnvironment(Environment actual, Environment wanted) =>
      actual == wanted
          ? (_environmentPoints, Some(EnvironmentMatch(actual)))
          : (0, const None());

  static _Criterion _light(Lighting plantLighting, Option<LightType> wanted) =>
      wanted.match(
        () => (_lightPoints, const None()),
        (light) => switch (
            (_lightRank(plantLighting) - _wantedLightRank(light)).abs()) {
          0 => (_lightPoints, const Some(LightMatch())),
          1 => (_nearLightPoints, const None()),
          _ => (0, const None()),
        },
      );

  static int _lightRank(Lighting lighting) => switch (lighting) {
        Lighting.shade => 0,
        Lighting.indirectLight => 1,
        Lighting.sun => 2,
      };

  static int _wantedLightRank(LightType light) => switch (light) {
        LowLight() => 0,
        IndirectLight() => 1,
        DirectLight() => 2,
      };

  static _Criterion _care(
    LevelMaintenance plantLevel,
    Option<CareLevelType> userLevel,
  ) =>
      userLevel.match(
        () => (_carePoints, const None()),
        (level) => _careRank(plantLevel) <= _userCareRank(level)
            ? (_carePoints, const Some(CareMatch()))
            : (0, const None()),
      );

  static int _careRank(LevelMaintenance level) => switch (level) {
        LevelMaintenance.low => 0,
        LevelMaintenance.medium => 1,
        LevelMaintenance.high => 2,
      };

  static int _userCareRank(CareLevelType level) => switch (level) {
        BeginnerCare() => 0,
        IntermediateCare() => 1,
        ExpertCare() => 2,
      };

  static _Criterion _proximity(Option<double> distanceKm) => distanceKm.match(
        () => (0, const None()),
        (km) => (
          (_proximityPoints * (1 - km / _proximityRangeKm))
              .clamp(0, _proximityPoints)
              .round(),
          Option.fromPredicate(km, (km) => km <= DistanceHelper.maxDistance)
              .map(NearbyMatch.new),
        ),
      );

  static _Criterion _petSafety(
    PetToxicity toxicity,
    Option<PetSafetyType> petSafety,
  ) =>
      petSafety.match(
        () => (0, const None()),
        (safety) => switch (safety) {
          SafeForPets() => switch (toxicity) {
              PetSafe() => (_verifiedPetSafePoints, const Some(PetSafeMatch())),
              PetToxicityUnknown() => (0, const Some(PetSafetyUnverified())),
              PetToxic() => (0, const None()),
            },
          IndifferentSafety() => (0, const None()),
        },
      );

  static int _freshness(DateTime createdAt, DateTime now) =>
      switch (now.difference(createdAt).inDays) {
        < 7 => 5,
        < 30 => 3,
        _ => 0,
      };

  static int _popularity(int views) => switch (views) {
        >= 50 => 5,
        >= 20 => 3,
        >= 5 => 1,
        _ => 0,
      };
}
