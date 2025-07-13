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
