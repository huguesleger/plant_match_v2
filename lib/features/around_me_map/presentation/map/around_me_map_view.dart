import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/cluster_marker.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_geo.dart';

class AroundMeMapView extends StatelessWidget {
  const AroundMeMapView({
    super.key,
    required this.mapController,
    required this.center,
    required this.initialZoom,
    required this.minZoom,
    required this.maxZoom,
    required this.radius,
    required this.currentUserMarker,
    required this.otherMarkers,
    required this.onZoomChanged,
  });

  final MapController mapController;
  final LatLng center;
  final double initialZoom;
  final double minZoom;
  final double maxZoom;
  final double radius;
  final Marker currentUserMarker;
  final List<Marker> otherMarkers;
  final ValueChanged<double> onZoomChanged;

  @override
  Widget build(BuildContext context) => FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: initialZoom,
          minZoom: minZoom,
          maxZoom: maxZoom,
          onPositionChanged: (position, _) => onZoomChanged(position.zoom),
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            cursorKeyboardRotationOptions:
                CursorKeyboardRotationOptions.disabled(),
          ),
        ),
        children: [
          TileLayer(
            userAgentPackageName: "com.plantmatch.app",
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          if (MapGeo.isLimited(radius))
            CircleLayer(
              circles: [
                CircleMarker(
                  point: center,
                  radius: radius * 1000,
                  useRadiusInMeter: true,
                  color: AppColors.blueGreen.withValues(alpha: 0.12),
                  borderColor: AppColors.blueGreen.withValues(alpha: 0.4),
                  borderStrokeWidth: 2,
                ),
              ],
            ),
          MarkerLayer(markers: [currentUserMarker]),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 50,
              size: const Size(44, 44),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(50),
              markers: otherMarkers,
              builder: (context, markers) =>
                  ClusterMarker(count: markers.length),
            ),
          ),
        ],
      );
}
