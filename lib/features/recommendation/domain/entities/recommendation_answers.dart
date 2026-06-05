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
    Option<EnvironmentType>? environment,
    Option<LightType>? light,
    Option<CareLevelType>? careLevel,
    Option<PetSafetyType>? petSafety,
  }) {
    return RecommendationAnswers(
      environment: environment ?? this.environment,
      light: light ?? this.light,
      careLevel: careLevel ?? this.careLevel,
      petSafety: petSafety ?? this.petSafety,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environment': environment.match(
        () => null,
        (env) => switch (env) {
          IndoorEnv() => 'indoor',
          OutdoorEnv() => 'outdoor',
          BothEnv() => 'both',
        },
      ),
      'light': light.match(
        () => null,
        (l) => switch (l) {
          LowLight() => 'low',
          IndirectLight() => 'indirect',
          DirectLight() => 'direct',
        },
      ),
      'careLevel': careLevel.match(
        () => null,
        (c) => switch (c) {
          BeginnerCare() => 'beginner',
          IntermediateCare() => 'intermediate',
          ExpertCare() => 'expert',
        },
      ),
      'petSafety': petSafety.match(
        () => null,
        (s) => switch (s) {
          SafeForPets() => 'safe',
          IndifferentSafety() => 'indifferent',
        },
      ),
    };
  }

  factory RecommendationAnswers.fromJson(Map<String, dynamic> json) {
    final envStr = json['environment'] as String?;
    final lightStr = json['light'] as String?;
    final careStr = json['careLevel'] as String?;
    final petStr = json['petSafety'] as String?;

    return RecommendationAnswers(
      environment: envStr == null
          ? none()
          : optionOf(switch (envStr) {
              'indoor' => IndoorEnv(),
              'outdoor' => OutdoorEnv(),
              'both' => BothEnv(),
              _ => null,
            }),
      light: lightStr == null
          ? none()
          : optionOf(switch (lightStr) {
              'low' => LowLight(),
              'indirect' => IndirectLight(),
              'direct' => DirectLight(),
              _ => null,
            }),
      careLevel: careStr == null
          ? none()
          : optionOf(switch (careStr) {
              'beginner' => BeginnerCare(),
              'intermediate' => IntermediateCare(),
              'expert' => ExpertCare(),
              _ => null,
            }),
      petSafety: petStr == null
          ? none()
          : optionOf(switch (petStr) {
              'safe' => SafeForPets(),
              'indifferent' => IndifferentSafety(),
              _ => null,
            }),
    );
  }
}
