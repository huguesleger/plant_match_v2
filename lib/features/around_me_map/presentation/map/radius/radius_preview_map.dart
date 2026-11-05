import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/current_user_marker.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_geo.dart';

class RadiusPreviewMap extends StatefulWidget {
  const RadiusPreviewMap({
    super.key,
    required this.center,
    required this.radiusKm,
    required this.fittedRadiusKm,
  });

  final LatLng center;
  final double radiusKm;
  final double fittedRadiusKm;

  @override
  State<RadiusPreviewMap> createState() => _RadiusPreviewMapState();
}

class _RadiusPreviewMapState extends State<RadiusPreviewMap>
    with TickerProviderStateMixin {
  late final AnimatedMapController _controller =
      AnimatedMapController(vsync: this);

  @override
  void didUpdateWidget(RadiusPreviewMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fittedRadiusKm != widget.fittedRadiusKm) _fitCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fitCamera() =>
      MapGeo.fitRadius(_controller, widget.center, widget.fittedRadiusKm);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          mapController: _controller.mapController,
          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: 10,
            onMapReady: _fitCamera,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              userAgentPackageName: 'com.plantmatch.app',
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            CircleLayer(
              circles: [
                CircleMarker(
                  point: widget.center,
                  radius: widget.radiusKm * 1000,
                  useRadiusInMeter: true,
                  color: AppColors.blueGreen.withValues(alpha: 0.12),
                  borderColor: AppColors.blueGreen.withValues(alpha: 0.4),
                  borderStrokeWidth: 2,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 30,
                  height: 30,
                  point: widget.center,
                  child: const CurrentUserMarker(),
                ),
              ],
            ),
          ],
        ),
      );
}
