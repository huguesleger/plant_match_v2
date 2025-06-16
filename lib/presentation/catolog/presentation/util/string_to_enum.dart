import 'package:plant_match_v2/presentation/catolog/domain/entity/catalog.dart';

T? stringToEnum<T>(String value, List<T> enumValues) {
  try {
    return enumValues.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
    );
  } catch (e) {
    return null; // Retourne null si la valeur ne correspond pas
  }
}

// Fonctions spécifiques pour chaque Enum
Environment? getEnvironmentFromString(String value) {
  print("getEnvironmentFromString: $value");
  return stringToEnum<Environment>(value, Environment.values);
}

/*Environment? getEnvironmentFromString(String value) {
  switch (value.toLowerCase()) {
    case 'intérieur':
      return Environment.indoor;
    case 'extérieur':
      return Environment.outdoor;
    default:
      return null;
  }
}*/

/*Family? getFamilyFromString(String value) {
  return stringToEnum<Family>(value, Family.values);
}*/

/*Family? getFamilyFromString(String value) {
  return Family.values.firstWhere((e) => e.name == value);
}*/
Family getFamilyFromString(String value) {
  return Family.values.firstWhere(
    (f) => f.name == value,
    orElse: () =>
        Family.aquatic, // Remplace par une valeur par défaut si nécessaire
  );
}

LevelMaintenance? getLevelMaintenanceFromString(String value) {
  return stringToEnum<LevelMaintenance>(value, LevelMaintenance.values);
}

Watering? getWateringFromString(String value) {
  return stringToEnum<Watering>(value, Watering.values);
}

Lighting? getLightingFromString(String value) {
  return stringToEnum<Lighting>(value, Lighting.values);
}
