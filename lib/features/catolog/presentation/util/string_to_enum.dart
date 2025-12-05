import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';

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
  return stringToEnum<Environment>(value, Environment.values);
}

String environmentToString(Environment env) {
  switch (env) {
    case Environment.indoor:
      return "indoor";
    case Environment.outdoor:
      return "outdoor";
  }
}

Family getFamilyFromString(String value) {
  return Family.values.firstWhere(
    (f) => f.name == value,
    orElse: () => Family.aquatic,
  );
}

LevelMaintenance? getLevelMaintenanceFromString(String value) {
  return stringToEnum<LevelMaintenance>(value, LevelMaintenance.values);
}

String maintenanceToString(LevelMaintenance level) {
  switch (level) {
    case LevelMaintenance.low:
      return "low";
    case LevelMaintenance.medium:
      return "medium";
    case LevelMaintenance.high:
      return "high";
  }
}

Watering? getWateringFromString(String value) {
  return stringToEnum<Watering>(value, Watering.values);
}

String wateringToString(Watering watering) {
  switch (watering) {
    case Watering.little:
      return "little";
    case Watering.regularly:
      return "regularly";
  }
}

Lighting? getLightingFromString(String value) {
  return stringToEnum<Lighting>(value, Lighting.values);
}

String lightingToString(Lighting lighting) {
  switch (lighting) {
    case Lighting.sun:
      return "sun";
    case Lighting.indirectLight:
      return "indirectLight";
    case Lighting.shade:
      return "shade";
  }
}

OfferType? getOfferTypeFromString(String value) {
  return stringToEnum<OfferType>(value, OfferType.values);
}

String offerTypeToString(OfferType offerType) {
  switch (offerType) {
    case OfferType.exchange:
      return "exchange";
    case OfferType.donation:
      return "donation";
  }
}
