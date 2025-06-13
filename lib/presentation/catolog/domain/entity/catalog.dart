class Catalog {
  final String uid;
  final userId;
  final String name;
  final String description;
  final String image;
  final Environment environment;
  final Family family;
  final LevelMaintenance levelMaintenance;
  final Watering watering;
  final Lighting lighting;

  Catalog({
    required this.uid,
    required this.userId,
    required this.name,
    required this.description,
    required this.image,
    required this.environment,
    required this.family,
    required this.levelMaintenance,
    required this.watering,
    required this.lighting,
  });

  Catalog copyWith({
    String? name,
    String? uid,
    String? description,
    String? image,
    Environment? environment,
    Family? family,
    LevelMaintenance? levelMaintenance,
    Watering? watering,
    Lighting? lighting,
  }) {
    return Catalog(
      uid: uid ?? this.uid,
      userId: userId,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      environment: environment ?? this.environment,
      family: family ?? this.family,
      levelMaintenance: levelMaintenance ?? this.levelMaintenance,
      watering: watering ?? this.watering,
      lighting: lighting ?? this.lighting,
    );
  }

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      uid: json['uid'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
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
      'userId': userId,
      'name': name,
      'description': description,
      'image': image,
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
