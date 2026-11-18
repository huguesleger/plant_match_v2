import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/recommendation/domain/entities/scored_plant.dart';

extension MatchReasonLabel on MatchReason {
  String get label => switch (this) {
        EnvironmentMatch(:final environment) => environment.envName,
        LightMatch() => t.recommendation.card.reasons.light,
        CareMatch() => t.recommendation.card.reasons.care,
        NearbyMatch(:final distanceKm) => t.recommendation.card.reasons
            .nearby(distance: distanceKm.toStringAsFixed(1)),
        PetSafeMatch() => t.recommendation.card.reasons.pet_safe,
        PetSafetyUnverified() => t.recommendation.card.reasons.pet_unverified,
      };
}
