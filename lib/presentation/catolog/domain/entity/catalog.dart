class Catalog {
  final String uid;
  final String name;
  final String description;
  final List<String> images;
  final Environment environment;
  final Family family;
  final LevelMaintenance levelMaintenance;
  final Watering watering;
  final Lighting lighting;

  Catalog({
    required this.uid,
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
    String? newName,
    String? newDescription,
    List<String>? newImages,
    Environment? newEnvironment,
    Family? newFamily,
    LevelMaintenance? newLevelMaintenance,
    Watering? newWatering,
    Lighting? newLighting,
  }) {
    return Catalog(
      uid: uid,
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

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      images: List<String>.from(json['images']),
      environment: Environment.values.byName(json['environment']),
      family: Family.values.byName(json['family']),
      levelMaintenance:
          LevelMaintenance.values.byName(json['levelMaintenance']),
      watering: Watering.values.byName(json['watering']),
      lighting: Lighting.values.byName(json['lighting']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'images': images,
      'environment': environment.name,
      'family': family.name,
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
