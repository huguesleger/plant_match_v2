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
  final OfferType offerType;

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
    required this.offerType,
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
    OfferType? newOfferType,
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
      offerType: newOfferType ?? offerType,
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
      offerType: OfferType.exchange,
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
      offerType: json['offerType'] != null
          ? OfferType.values.byName(json['offerType'])
          : OfferType.exchange,
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
      'offerType': offerType.name,
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

enum OfferType {
  exchange,
  donation,
}

extension LightingExtension on Lighting {
  String get lightingName => switch (this) {
        Lighting.sun => 'Soleil',
        Lighting.indirectLight => 'Indirecte',
        Lighting.shade => 'Ombre',
      };
}

extension EnvironmentExtension on Environment {
  String get envName => switch (this) {
        Environment.indoor => 'Intérieur',
        Environment.outdoor => 'Extérieur',
      };
}

extension FamilyExtension on Family {
  String get familyName => switch (this) {
        Family.tropical => 'Tropicale',
        Family.succulent => 'Succulente',
        Family.aquatic => 'Aquatique',
        Family.climbing => 'Grimpante',
        Family.bonsai => 'Bonsaï',
        Family.flower => 'Fleurie',
        Family.aromatic => 'Aromatique',
        Family.medical => 'Médicinale',
        Family.carnivorous => 'Carnivore',
      };
}

extension LevelMaintenanceExtension on LevelMaintenance {
  String get levelName => switch (this) {
        LevelMaintenance.low => 'Facile',
        LevelMaintenance.medium => 'Moyen',
        LevelMaintenance.high => 'Difficile',
      };
}

extension WateringExtension on Watering {
  String get wateringName => switch (this) {
        Watering.little => 'Peu d\'eau',
        Watering.regularly => 'Régulier',
      };
}

extension OfferTypeExtension on OfferType {
  String get offerTypeName => switch (this) {
        OfferType.exchange => 'Échange',
        OfferType.donation => 'Donation',
      };

  static OfferType fromString(String value) {
    final normalized = value.toLowerCase().trim();

    if (normalized == 'échange') {
      return OfferType.exchange;
    }
    if (normalized == 'donation') {
      return OfferType.donation;
    }
    return OfferType.donation;
  }
}
