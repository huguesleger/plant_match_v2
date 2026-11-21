import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class FamilyPlant {
  final Catalog catalog;
  final ProfilUser owner;
  final Option<double> distanceKm;

  const FamilyPlant({
    required this.catalog,
    required this.owner,
    required this.distanceKm,
  });

  factory FamilyPlant.boneMock() => FamilyPlant(
        catalog: Catalog.boneMock(),
        owner: ProfilUser.boneMock(),
        distanceKm: const Some(1.5),
      );

  static List<FamilyPlant> from({
    required ProfilUser currentUser,
    required List<ProfilUser> users,
    required Map<String, List<Catalog>> userCatalogs,
    required Family family,
  }) =>
      userCatalogs.entries
          .where((entry) => entry.key != currentUser.uid)
          .expand(
            (entry) =>
                users.where((user) => user.uid == entry.key).firstOption.match(
                      () => const <FamilyPlant>[],
                      (owner) => entry.value
                          .where((catalog) =>
                              catalog.status == CatalogStatus.published &&
                              catalog.family.contains(family))
                          .map((catalog) => FamilyPlant(
                                catalog: catalog,
                                owner: owner,
                                distanceKm: DistanceHelper.distanceBetween(
                                  currentUser,
                                  owner,
                                ),
                              )),
                    ),
          )
          .toList()
        ..sort(_byDistanceThenDate);

  static int _byDistanceThenDate(FamilyPlant a, FamilyPlant b) =>
      a.distanceKm.match(
        () => b.distanceKm.match(() => _byDate(a, b), (_) => 1),
        (distanceA) => b.distanceKm.match(
          () => -1,
          (distanceB) => distanceA != distanceB
              ? distanceA.compareTo(distanceB)
              : _byDate(a, b),
        ),
      );

  static int _byDate(FamilyPlant a, FamilyPlant b) =>
      b.catalog.createdAt.compareTo(a.catalog.createdAt);
}
