import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class DistanceHelper {
  static double maxDistance = 15.0;

  static double coarse(double coordinate) =>
      (coordinate * 100).roundToDouble() / 100;

  static String get maxDistanceFormatted =>
      maxDistance == double.infinity ? 'National' : '${maxDistance.toInt()} km';

  static Option<LatLng> locationOf(ProfilUser user) => user.latitude
      .flatMap((lat) => user.longitude.map((lng) => LatLng(lat, lng)))
      .filter((point) => point.latitude != 0 || point.longitude != 0);

  static bool hasValidLocation(ProfilUser user) => locationOf(user).isSome();

  static Option<double> distanceBetween(ProfilUser user1, ProfilUser user2) =>
      user1.uid == user2.uid
          ? const Some(0.0)
          : locationOf(user1).flatMap(
              (from) => locationOf(user2).map((to) => _kilometers(from, to)),
            );

  static bool isWithin(ProfilUser user1, ProfilUser user2, double radius) =>
      distanceBetween(user1, user2).match(() => false, (km) => km <= radius);

  static double calculateDistance(ProfilUser user1, ProfilUser user2) =>
      distanceBetween(user1, user2).getOrElse(() => 0.0);

  static double _kilometers(LatLng from, LatLng to) => double.parse(
        (const Distance().as(LengthUnit.Meter, from, to) / 1000)
            .toStringAsFixed(2),
      );
}
