import 'package:flutter_map/flutter_map.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_geo.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_marker.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class MapMarkers {
  const MapMarkers({required this.currentUser, required this.userCatalogs});

  final ProfilUser currentUser;
  final Map<String, List<Catalog>> userCatalogs;

  Marker forCurrentUser() => _markerFor(currentUser, isCurrentUser: true);

  List<Marker> around(List<ProfilUser> users, double radius) => users
      .where((user) => user.uid != currentUser.uid)
      .where(MapGeo.hasValidLocation)
      .where((user) =>
          DistanceHelper.calculateDistance(currentUser, user) <= radius)
      .map((user) => _markerFor(user, isCurrentUser: false))
      .toList();

  Marker _markerFor(ProfilUser user, {required bool isCurrentUser}) => Marker(
        width: 40.0,
        height: 40.0,
        point: MapGeo.positionOf(user),
        child: MapMarker(
          user: user,
          isCurrentUser: isCurrentUser,
          distance: isCurrentUser
              ? 0
              : DistanceHelper.calculateDistance(currentUser, user),
          catalogs: userCatalogs[user.uid] ?? [],
        ),
      );
}
