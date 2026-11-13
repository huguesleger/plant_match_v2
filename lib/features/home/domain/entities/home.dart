import 'package:fpdart/fpdart.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/user/domain/entities/catalog_filter.dart';

class Home {
  final ProfilUser currentUser;
  final List<ProfilUser> users;
  final Map<String, List<Catalog>> userCatalogs;
  final List<(Catalog, ProfilUser, double)> nearbyPlants;
  final List<(Catalog, ProfilUser)> recentActivities;
  final bool isGeolocated;

  const Home({
    required this.currentUser,
    required this.users,
    required this.userCatalogs,
    required this.nearbyPlants,
    required this.recentActivities,
    required this.isGeolocated,
  });

  static const _recentActivitiesLimit = 5;

  factory Home.fromAroundMe({
    required ProfilUser currentUser,
    required List<ProfilUser> users,
    required Map<String, List<Catalog>> userCatalogs,
    required CatalogFilter filter,
  }) {
    final others = _otherOwners(currentUser, users, userCatalogs);
    return Home(
      currentUser: currentUser,
      users: users,
      userCatalogs: userCatalogs,
      nearbyPlants: _nearbyPlants(currentUser, others, filter),
      recentActivities: _recentActivities(others),
      isGeolocated: DistanceHelper.hasValidLocation(currentUser),
    );
  }

  factory Home.boneMock() => Home(
        currentUser: ProfilUser.boneMock(),
        users: const [],
        userCatalogs: const {},
        nearbyPlants: List.generate(
          3,
          (_) => (Catalog.boneMock(), ProfilUser.boneMock(), 1.5),
        ),
        recentActivities: List.generate(
          3,
          (_) => (Catalog.boneMock(), ProfilUser.boneMock()),
        ),
        isGeolocated: true,
      );

  Home withFilter(CatalogFilter filter) => Home.fromAroundMe(
        currentUser: currentUser,
        users: users,
        userCatalogs: userCatalogs,
        filter: filter,
      );

  static List<(ProfilUser, List<Catalog>)> _otherOwners(
    ProfilUser currentUser,
    List<ProfilUser> users,
    Map<String, List<Catalog>> userCatalogs,
  ) =>
      userCatalogs.entries
          .where((entry) => entry.key != currentUser.uid)
          .expand(
            (entry) =>
                users.where((user) => user.uid == entry.key).firstOption.match(
                      () => const <(ProfilUser, List<Catalog>)>[],
                      (owner) => [(owner, entry.value)],
                    ),
          )
          .toList();

  static List<(Catalog, ProfilUser, double)> _nearbyPlants(
    ProfilUser currentUser,
    List<(ProfilUser, List<Catalog>)> others,
    CatalogFilter filter,
  ) =>
      others
          .expand(
            (other) => DistanceHelper.distanceBetween(currentUser, other.$1)
                .filter((km) => km <= DistanceHelper.maxDistance)
                .match(
                  () => const <(Catalog, ProfilUser, double)>[],
                  (km) => other.$2
                      .where((catalog) => _matches(catalog, filter))
                      .map((catalog) => (catalog, other.$1, km)),
                ),
          )
          .toList()
        ..sort((a, b) => a.$3.compareTo(b.$3));

  static List<(Catalog, ProfilUser)> _recentActivities(
    List<(ProfilUser, List<Catalog>)> others,
  ) =>
      (others
              .expand(
                (other) => other.$2
                    .where(_isPublished)
                    .map((catalog) => (catalog, other.$1)),
              )
              .toList()
            ..sort((a, b) => b.$1.createdAt.compareTo(a.$1.createdAt)))
          .take(_recentActivitiesLimit)
          .toList();

  static bool _isPublished(Catalog catalog) =>
      catalog.status == CatalogStatus.published;

  static bool _matches(Catalog catalog, CatalogFilter filter) =>
      _isPublished(catalog) &&
      switch (filter) {
        CatalogFilter.all => true,
        CatalogFilter.donation => catalog.offerType == OfferType.donation,
        CatalogFilter.exchange => catalog.offerType == OfferType.exchange,
        CatalogFilter.outdoor => catalog.environment == Environment.outdoor,
        CatalogFilter.indoor => catalog.environment == Environment.indoor,
      };
}
