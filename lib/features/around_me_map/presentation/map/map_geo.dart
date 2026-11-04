import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:fpdart/fpdart.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class MapGeo {
  static const double unlimitedRadius = 99999.0;

  static LatLng positionOf(ProfilUser user) => LatLng(
        user.latitude.getOrElse(() => 0.0),
        user.longitude.getOrElse(() => 0.0),
      );

  static bool hasValidLocation(ProfilUser user) =>
      DistanceHelper.hasValidLocation(user);

  static bool isLimited(double radius) => radius < unlimitedRadius;

  static LatLngBounds boundsFromRadius(LatLng center, double radiusInKm) {
    final dLat = radiusInKm / 111.1;
    final latRad = center.latitude * math.pi / 180.0;
    final dLon = radiusInKm / (111.1 * math.cos(latRad));
    return LatLngBounds(
      LatLng(center.latitude - dLat, center.longitude - dLon),
      LatLng(center.latitude + dLat, center.longitude + dLon),
    );
  }

  static void fitRadius(
    AnimatedMapController controller,
    LatLng center,
    double radiusInKm,
  ) =>
      controller.animatedFitCamera(
        cameraFit: CameraFit.bounds(
          bounds: boundsFromRadius(center, radiusInKm),
          padding: const EdgeInsets.all(20),
        ),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
}
