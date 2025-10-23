import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

extension FamilyExtension on Family {
  static const Map<Family, String> _translations = {
    Family.tropical: 'tropical',
    Family.succulent: 'succulente',
    Family.aquatic: 'aquatique',
    Family.climbing: 'grimpante',
    Family.bonsai: 'bonsaï',
    Family.flower: 'florale',
    Family.aromatic: 'aromatique',
    Family.medical: 'médicinale',
    Family.carnivorous: 'carnivore',
  };

  String get familyName => _translations[this] ?? 'unknown';

  static Family fromName(String name) {
    return _translations.entries
        .firstWhere((entry) => entry.value == name,
            orElse: () => const MapEntry(Family.aquatic, 'aquatique'))
        .key;
  }
}
