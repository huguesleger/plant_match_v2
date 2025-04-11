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

Family? getFamilyFromString(String value) {
  return stringToEnum<Family>(value, Family.values);
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
