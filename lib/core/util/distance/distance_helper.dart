import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class DistanceHelper {
  static const double maxDistance = 05.0;

  static String get maxDistanceFormatted => '${maxDistance.toInt()} km';

  static double calculateDistance(ProfilUser user1, ProfilUser user2) {
    if (user1.uid == user2.uid) return 0.0;

    final lat1 = user1.latitude.getOrElse(() => 0.0);
    final lon1 = user1.longitude.getOrElse(() => 0.0);
    final lat2 = user2.latitude.getOrElse(() => 0.0);
    final lon2 = user2.longitude.getOrElse(() => 0.0);

    const distance = Distance();
    final meters = distance.as(
      LengthUnit.Meter,
      LatLng(lat1, lon1),
      LatLng(lat2, lon2),
    );
    return double.parse((meters / 1000).toStringAsFixed(2));
  }
}
