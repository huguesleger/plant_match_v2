import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

extension EnvironmentExtension on Environment {
  static const Map<Environment, String> _translations = {
    Environment.indoor: 'intérieur',
    Environment.outdoor: 'extérieur',
  };

  String get envName => _translations[this] ?? 'inconnu';

  static Environment fromName(String name) {
    return _translations.entries
        .firstWhere((e) => e.value == name,
            orElse: () => const MapEntry(Environment.indoor, 'intérieur'))
        .key;
  }
}
