import 'package:plant_match_v2/core/util/json_reader.dart';
import 'package:fpdart/fpdart.dart';

sealed class EnvironmentType {
  const EnvironmentType();
}

class IndoorEnv extends EnvironmentType {}
class OutdoorEnv extends EnvironmentType {}
class BothEnv extends EnvironmentType {}

sealed class LightType {
  const LightType();
}

class LowLight extends LightType {}
class IndirectLight extends LightType {}
class DirectLight extends LightType {}

sealed class CareLevelType {
  const CareLevelType();
}

class BeginnerCare extends CareLevelType {}
class IntermediateCare extends CareLevelType {}
class ExpertCare extends CareLevelType {}

sealed class PetSafetyType {
  const PetSafetyType();
}

class SafeForPets extends PetSafetyType {}
class IndifferentSafety extends PetSafetyType {}

class RecommendationAnswers {
  final Option<EnvironmentType> environment;
  final Option<LightType> light;
  final Option<CareLevelType> careLevel;
  final Option<PetSafetyType> petSafety;

  const RecommendationAnswers({
    required this.environment,
    required this.light,
    required this.careLevel,
    required this.petSafety,
  });

  factory RecommendationAnswers.empty() => RecommendationAnswers(
        environment: none(),
        light: none(),
        careLevel: none(),
        petSafety: none(),
      );

  RecommendationAnswers copyWith({
    Option<Option<EnvironmentType>> environment = const None(),
    Option<Option<LightType>> light = const None(),
    Option<Option<CareLevelType>> careLevel = const None(),
    Option<Option<PetSafetyType>> petSafety = const None(),
  }) {
    return RecommendationAnswers(
      environment: environment.getOrElse(() => this.environment),
      light: light.getOrElse(() => this.light),
      careLevel: careLevel.getOrElse(() => this.careLevel),
      petSafety: petSafety.getOrElse(() => this.petSafety),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environment': environment
          .map((env) => switch (env) {
                IndoorEnv() => 'indoor',
                OutdoorEnv() => 'outdoor',
                BothEnv() => 'both',
              })
          .toNullable(),
      'light': light
          .map((l) => switch (l) {
                LowLight() => 'low',
                IndirectLight() => 'indirect',
                DirectLight() => 'direct',
              })
          .toNullable(),
      'careLevel': careLevel
          .map((c) => switch (c) {
                BeginnerCare() => 'beginner',
                IntermediateCare() => 'intermediate',
                ExpertCare() => 'expert',
              })
          .toNullable(),
      'petSafety': petSafety
          .map((s) => switch (s) {
                SafeForPets() => 'safe',
                IndifferentSafety() => 'indifferent',
              })
          .toNullable(),
    };
  }

  factory RecommendationAnswers.fromJson(Map<String, dynamic> json) {
    Option<T> pick<T>(String key, Map<String, T> values) =>
        json.read<String>(key).flatMap((raw) => Option.fromNullable(values[raw]));

    return RecommendationAnswers(
      environment: pick<EnvironmentType>('environment', {
        'indoor': IndoorEnv(),
        'outdoor': OutdoorEnv(),
        'both': BothEnv(),
      }),
      light: pick<LightType>('light', {
        'low': LowLight(),
        'indirect': IndirectLight(),
        'direct': DirectLight(),
      }),
      careLevel: pick<CareLevelType>('careLevel', {
        'beginner': BeginnerCare(),
        'intermediate': IntermediateCare(),
        'expert': ExpertCare(),
      }),
      petSafety: pick<PetSafetyType>('petSafety', {
        'safe': SafeForPets(),
        'indifferent': IndifferentSafety(),
      }),
    );
  }
}
