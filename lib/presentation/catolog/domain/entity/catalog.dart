class Catalog {
  final String uid;
  final String userId;
  final String name;
  final String description;
  final String image;
  final Environment? environment;
  final List<Family>? family;
  final LevelMaintenance? levelMaintenance;
  final Watering? watering;
  final Lighting? lighting;

  Catalog({
    required this.uid,
    required this.userId,
    required this.name,
    required this.description,
    required this.image,
    this.environment,
    this.family,
    this.levelMaintenance,
    this.watering,
    this.lighting,
  });

  Catalog copyWith({
    String? name,
    String? uid,
    String? userId,
    String? description,
    String? image,
    Environment? environment,
    List<Family>? family,
    LevelMaintenance? levelMaintenance,
    Watering? watering,
    Lighting? lighting,
  }) {
    return Catalog(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
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
      uid: json['uid'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      environment: json['environment'] != null
          ? Environment.values.byName(json['environment'])
          : null,
      family: json['family'] != null && json['family'] is List
          ? (json['family'] as List<dynamic>)
              .map((e) => Family.values.byName(e.toString()))
              .toList()
          : null,
      levelMaintenance: json['levelMaintenance'] != null
          ? LevelMaintenance.values.byName(json['levelMaintenance'])
          : null,
      watering: json['watering'] != null
          ? Watering.values.byName(json['watering'])
          : null,
      lighting: json['lighting'] != null
          ? Lighting.values.byName(json['lighting'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userId': userId,
      'name': name,
      'description': description,
      'image': image,
      'environment': environment?.name,
      'family': family?.map((e) => e.name).toList() ?? [],
      'levelMaintenance': levelMaintenance?.name,
      'watering': watering?.name,
      'lighting': lighting?.name,
    };
  }
}

enum Environment {
  indoor,
  outdoor,
  uknown,
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
