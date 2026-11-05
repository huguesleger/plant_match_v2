import 'package:plant_match_v2/core/util/json_reader.dart';
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
  final int views;

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
    required this.views,
  });

  Catalog copyWith({
    Option<String> newUserId = const None(),
    Option<Option<String>> newCatalogId = const None(),
    Option<String> newName = const None(),
    Option<String> newDescription = const None(),
    Option<List<String>> newImages = const None(),
    Option<Environment> newEnvironment = const None(),
    Option<List<Family>> newFamily = const None(),
    Option<LevelMaintenance> newLevelMaintenance = const None(),
    Option<Watering> newWatering = const None(),
    Option<Lighting> newLighting = const None(),
    Option<CatalogStatus> newStatus = const None(),
    Option<DateTime> newCreatedAt = const None(),
    Option<OfferType> newOfferType = const None(),
    Option<int> newViews = const None(),
  }) {
    return Catalog(
      userId: newUserId.getOrElse(() => userId),
      catalogId: newCatalogId.getOrElse(() => catalogId),
      name: newName.getOrElse(() => name),
      description: newDescription.getOrElse(() => description),
      images: newImages.getOrElse(() => images),
      environment: newEnvironment.getOrElse(() => environment),
      family: newFamily.getOrElse(() => family),
      levelMaintenance: newLevelMaintenance.getOrElse(() => levelMaintenance),
      watering: newWatering.getOrElse(() => watering),
      lighting: newLighting.getOrElse(() => lighting),
      status: newStatus.getOrElse(() => status),
      createdAt: newCreatedAt.getOrElse(() => createdAt),
      offerType: newOfferType.getOrElse(() => offerType),
      views: newViews.getOrElse(() => views),
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
      views: 0,
    );
  }

  static T _enumOr<T extends Enum>(List<T> values, dynamic raw, T fallback) =>
      Option.fromNullable(values.asNameMap()[raw]).getOrElse(() => fallback);

  factory Catalog.fromJson(Map<String, dynamic> json, String id) {
    final legacyStatus = json['isPublish'] == true
        ? CatalogStatus.published
        : CatalogStatus.draft;
    final createdAt = json['createdAt'];

    return Catalog(
      userId: json.string('userId'),
      catalogId: Option.fromNullable(id),
      name: json.string('name'),
      description: json.string('description'),
      images:
          json.listOf<String>('images'),
      environment:
          _enumOr(Environment.values, json['environment'], Environment.outdoor),
      family: json.listOf<Object>('family')
          .map((e) => Option.fromNullable(Family.values.asNameMap()[e]))
          .whereType<Some<Family>>()
          .map((found) => found.value)
          .toList(),
      levelMaintenance: _enumOr(
        LevelMaintenance.values,
        json['levelMaintenance'],
        LevelMaintenance.low,
      ),
      watering: _enumOr(Watering.values, json['watering'], Watering.regularly),
      lighting:
          _enumOr(Lighting.values, json['lighting'], Lighting.indirectLight),
      status: _enumOr(CatalogStatus.values, json['status'], legacyStatus),
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      offerType:
          _enumOr(OfferType.values, json['offerType'], OfferType.exchange),
      views: json.integer('views'),
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
      'views': views,
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
