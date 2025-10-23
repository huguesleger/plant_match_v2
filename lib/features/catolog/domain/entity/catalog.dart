import 'package:cloud_firestore/cloud_firestore.dart';

class Catalog {
  final String userId;
  final String? catalogId;
  final String name;
  final String description;
  final List<String> images;
  final Environment environment;
  final List<Family> family;
  final LevelMaintenance levelMaintenance;
  final Watering watering;
  final Lighting lighting;
  final bool isPublish;
  final DateTime createdAt;

  Catalog({
    required this.userId,
    this.catalogId,
    required this.name,
    required this.description,
    required this.images,
    required this.environment,
    required this.family,
    required this.levelMaintenance,
    required this.watering,
    required this.lighting,
    required this.isPublish,
    required this.createdAt,
  });

  Catalog copyWith({
    String? newUserId,
    String? newCatalogId,
    String? newName,
    String? newDescription,
    List<String>? newImages,
    Environment? newEnvironment,
    List<Family>? newFamily,
    LevelMaintenance? newLevelMaintenance,
    Watering? newWatering,
    Lighting? newLighting,
    bool? newIsPublish,
    DateTime? newCreatedAt,
  }) {
    return Catalog(
      userId: newUserId ?? userId,
      catalogId: newCatalogId ?? catalogId,
      name: newName ?? name,
      description: newDescription ?? description,
      images: newImages ?? images,
      environment: newEnvironment ?? environment,
      family: newFamily ?? family,
      levelMaintenance: newLevelMaintenance ?? levelMaintenance,
      watering: newWatering ?? watering,
      lighting: newLighting ?? lighting,
      isPublish: newIsPublish ?? isPublish,
      createdAt: newCreatedAt ?? createdAt,
    );
  }

  factory Catalog.empty(String userId) {
    return Catalog(
      userId: userId,
      catalogId: null,
      name: '',
      description: '',
      images: [],
      environment: Environment.indoor,
      family: [Family.flower],
      levelMaintenance: LevelMaintenance.low,
      watering: Watering.little,
      lighting: Lighting.sun,
      isPublish: false,
      createdAt: DateTime.now(),
    );
  }

  factory Catalog.fromJson(Map<String, dynamic> json, String id) {
    return Catalog(
      userId: json['userId'] ?? '',
      catalogId: id,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      environment: json['environment'] != null
          ? Environment.values.byName(json['environment'])
          : Environment.outdoor,
      family: json['family'] != null
          ? (json['family'] as List)
              .map((e) => Family.values.byName(e))
              .toList()
          : [],
      levelMaintenance: json['levelMaintenance'] != null
          ? LevelMaintenance.values.byName(json['levelMaintenance'])
          : LevelMaintenance.low,
      watering: json['watering'] != null
          ? Watering.values.byName(json['watering'])
          : Watering.regularly,
      lighting: json['lighting'] != null
          ? Lighting.values.byName(json['lighting'])
          : Lighting.indirectLight,
      isPublish: json['isPublish'] ?? false,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'description': description,
      'images': images,
      'environment': environment.name,
      'family': family.map((e) => e.name).toList(),
      'levelMaintenance': levelMaintenance.name,
      'watering': watering.name,
      'lighting': lighting.name,
      'isPublish': isPublish,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum Environment {
  indoor,
  outdoor,
}

enum Family {
  tropical,
  succulent,
  aquatic,
  climbing,
  bonsai,
  flower,
  aromatic,
  medical,
  carnivorous,
}

enum LevelMaintenance {
  low,
  medium,
  high,
}

enum Watering {
  little,
  regularly,
}

enum Lighting {
  sun,
  indirectLight,
  shade,
}

/*extension EnvironmentExtension on Environment {
  String get envName {
    switch (this) {
      case Environment.indoor:
        return 'Intérieur';
      case Environment.outdoor:
        return 'Extérieur';
    }
  }
}*/

/*extension FamilyExtension on Family {
  String get familyName {
    switch (this) {
      case Family.tropical:
        return 'Tropicale';
      case Family.succulent:
        return 'Succulente';
      case Family.aquatic:
        return 'Aquatique';
      case Family.climbing:
        return 'Grimpante';
      case Family.bonsai:
        return 'Bonsaï';
      case Family.flower:
        return 'Fleurie';
      case Family.aromatic:
        return 'Aromatique';
      case Family.medical:
        return 'Médicinale';
      case Family.carnivorous:
        return 'Carnivore';
    }
  }
}*/

/*extension LevelMaintenanceExtension on LevelMaintenance {
  String get levelName {
    switch (this) {
      case LevelMaintenance.low:
        return 'Entretien faible';
      case LevelMaintenance.medium:
        return 'Entretien moyen';
      case LevelMaintenance.high:
        return 'Entretien élevé';
    }
  }
}*/

/*extension WateringExtension on Watering {
  String get wateringName {
    switch (this) {
      case Watering.little:
        return 'Peu d\'eau';
      case Watering.regularly:
        return 'Régulièrement';
    }
  }
}*/

/*extension LightingExtension on Lighting {
  String get lightingName {
    switch (this) {
      case Lighting.sun:
        return 'Ensoleillé';
      case Lighting.indirectLight:
        return 'Lumière indirecte';
      case Lighting.shade:
        return 'Ombre';
    }
  }
}*/
