import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:plant_match_v2/core/i18n/translations.g.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';

enum CatalogStatus {
  draft,
  published,
  archived,
}

extension CatalogStatusExtension on CatalogStatus {
  String get label => switch (this) {
        CatalogStatus.draft => t.catalog.status.draft,
        CatalogStatus.published => t.catalog.status.published,
        CatalogStatus.archived => t.catalog.status.archived,
      };

  Color get badgeColor => switch (this) {
        CatalogStatus.draft => AppColors.greyLight,
        CatalogStatus.published => AppColors.greenDark,
        CatalogStatus.archived => AppColors.greyMedium,
      };

  Color get textColor => switch (this) {
        CatalogStatus.draft => AppColors.greyMedium,
        CatalogStatus.published => AppColors.white,
        CatalogStatus.archived => AppColors.white,
      };
}

class Catalog {
  final String userId;
  final Option<String> catalogId;
  final String name;
  final String description;
  final List<String> images;
  final Environment environment;
  final List<Family> family;
  final LevelMaintenance levelMaintenance;
  final Watering watering;
  final Lighting lighting;
  final CatalogStatus status;
  final DateTime createdAt;
  final OfferType offerType;

  Catalog({
    required this.userId,
    required this.catalogId,
    required this.name,
    required this.description,
    required this.images,
    required this.environment,
    required this.family,
    required this.levelMaintenance,
    required this.watering,
    required this.lighting,
    required this.status,
    required this.createdAt,
    required this.offerType,
  });

  Catalog copyWith({
    String? newUserId,
    Option<String>? newCatalogId,
    String? newName,
    String? newDescription,
    List<String>? newImages,
    Environment? newEnvironment,
    List<Family>? newFamily,
    LevelMaintenance? newLevelMaintenance,
    Watering? newWatering,
    Lighting? newLighting,
    CatalogStatus? newStatus,
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
      status: newStatus ?? status,
      createdAt: newCreatedAt ?? createdAt,
      offerType: newOfferType ?? offerType,
    );
  }

  factory Catalog.empty(String userId) {
    return Catalog(
      userId: userId,
      catalogId: const None(),
      name: '',
      description: '',
      images: [],
      environment: Environment.indoor,
      family: [Family.flower],
      levelMaintenance: LevelMaintenance.low,
      watering: Watering.little,
      lighting: Lighting.sun,
      status: CatalogStatus.draft,
      createdAt: DateTime.now(),
      offerType: OfferType.exchange,
    );
  }

  factory Catalog.fromJson(Map<String, dynamic> json, String id) {
    // Rétrocompatibilité : migration depuis isPublish vers status
    CatalogStatus status;
    if (json['status'] != null) {
      status = CatalogStatus.values.byName(json['status']);
    } else {
      // Migration automatique depuis isPublish
      final isPublish = json['isPublish'] ?? false;
      status = isPublish ? CatalogStatus.published : CatalogStatus.draft;
    }

    return Catalog(
      userId: json['userId'] ?? '',
      catalogId: Option.fromNullable(id),
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
      status: status,
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
      'status': status.name,
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
        Lighting.sun => t.catalog.enums.lighting.sun,
        Lighting.indirectLight => t.catalog.enums.lighting.indirect,
        Lighting.shade => t.catalog.enums.lighting.shade,
      };
}

extension EnvironmentExtension on Environment {
  String get envName => switch (this) {
        Environment.indoor => t.catalog.enums.environment.indoor,
        Environment.outdoor => t.catalog.enums.environment.outdoor,
      };
}

extension FamilyExtension on Family {
  String get familyName => switch (this) {
        Family.tropical => t.catalog.families.tropical,
        Family.succulent => t.catalog.families.succulent,
        Family.aquatic => t.catalog.families.aquatic,
        Family.climbing => t.catalog.families.climbing,
        Family.bonsai => t.catalog.families.bonsai,
        Family.flower => t.catalog.families.flower,
        Family.aromatic => t.catalog.families.aromatic,
        Family.medical => t.catalog.families.medical,
        Family.carnivorous => t.catalog.families.carnivorous,
      };
}

extension LevelMaintenanceExtension on LevelMaintenance {
  String get levelName => switch (this) {
        LevelMaintenance.low => t.catalog.enums.maintenance.low,
        LevelMaintenance.medium => t.catalog.enums.maintenance.medium,
        LevelMaintenance.high => t.catalog.enums.maintenance.high,
      };
}

extension WateringExtension on Watering {
  String get wateringName => switch (this) {
        Watering.little => t.catalog.enums.watering.little,
        Watering.regularly => t.catalog.enums.watering.regularly,
      };
}

extension OfferTypeExtension on OfferType {
  String get offerTypeName => switch (this) {
        OfferType.exchange => t.catalog.enums.offer_type.exchange,
        OfferType.donation => t.catalog.enums.offer_type.donation,
      };
}
