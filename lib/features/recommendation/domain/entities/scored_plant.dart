import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

sealed class MatchReason {
  const MatchReason();
}

class EnvironmentMatch extends MatchReason {
  final Environment environment;

  const EnvironmentMatch(this.environment);
}

class LightMatch extends MatchReason {
  const LightMatch();
}

class CareMatch extends MatchReason {
  const CareMatch();
}

class NearbyMatch extends MatchReason {
  final double distanceKm;

  const NearbyMatch(this.distanceKm);
}

class PetSafeMatch extends MatchReason {
  const PetSafeMatch();
}

class PetSafetyUnverified extends MatchReason {
  const PetSafetyUnverified();
}

class ScoredPlant {
  final Catalog plant;
  final int score;
  final List<MatchReason> reasons;

  const ScoredPlant({
    required this.plant,
    required this.score,
    required this.reasons,
  });

  factory ScoredPlant.boneMock() => ScoredPlant(
        plant: Catalog.boneMock(),
        score: 80,
        reasons: const [LightMatch(), CareMatch()],
      );
}
