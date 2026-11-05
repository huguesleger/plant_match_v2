import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';

class AddPlantDraft {
  const AddPlantDraft({
    required this.catalog,
    this.environment = const None(),
    this.families = const [],
    this.maintenance = const None(),
    this.watering = const None(),
    this.lighting = const None(),
    this.offerType = const None(),
    this.publish = true,
  });

  final Catalog catalog;
  final Option<Environment> environment;
  final List<Family> families;
  final Option<LevelMaintenance> maintenance;
  final Option<Watering> watering;
  final Option<Lighting> lighting;
  final Option<OfferType> offerType;
  final bool publish;

  AddPlantDraft copyWith({
    Option<Catalog> catalog = const None(),
    Option<Environment> environment = const None(),
    Option<List<Family>> families = const None(),
    Option<LevelMaintenance> maintenance = const None(),
    Option<Watering> watering = const None(),
    Option<Lighting> lighting = const None(),
    Option<OfferType> offerType = const None(),
    Option<bool> publish = const None(),
  }) =>
      AddPlantDraft(
        catalog: catalog.getOrElse(() => this.catalog),
        environment: environment.alt(() => this.environment),
        families: families.getOrElse(() => this.families),
        maintenance: maintenance.alt(() => this.maintenance),
        watering: watering.alt(() => this.watering),
        lighting: lighting.alt(() => this.lighting),
        offerType: offerType.alt(() => this.offerType),
        publish: publish.getOrElse(() => this.publish),
      );

  AddPlantDraft toggleFamily(Family family) => copyWith(
        families: Some(
          families.contains(family)
              ? families.where((f) => f != family).toList()
              : [...families, family],
        ),
      );

  Catalog toCatalog({required String name, required String description}) =>
      catalog.copyWith(
        newName: Some(name),
        newDescription: Some(description),
        newEnvironment: Some(environment.getOrElse(() => Environment.indoor)),
        newFamily: Some(families),
        newLevelMaintenance:
            Some(maintenance.getOrElse(() => LevelMaintenance.low)),
        newWatering: Some(watering.getOrElse(() => Watering.little)),
        newLighting: Some(lighting.getOrElse(() => Lighting.sun)),
        newOfferType: Some(offerType.getOrElse(() => OfferType.exchange)),
        newStatus:
            Some(publish ? CatalogStatus.published : CatalogStatus.draft),
      );
}
