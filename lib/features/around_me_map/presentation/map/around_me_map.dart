import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_colors.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/core/util/distance/distance_helper.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/cluster_marker.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_controls.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_marker.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/radius_filter_page.dart';

class AroundMeMap extends StatefulWidget {
  const AroundMeMap({
    super.key,
    required this.users,
    required this.currentUser,
    required this.userCatalogs,
  });

  final List<ProfilUser> users;
  final ProfilUser currentUser;
  final Map<String, List<Catalog>> userCatalogs;

  @override
  State<AroundMeMap> createState() => _AroundMeMapState();
}

class _AroundMeMapState extends State<AroundMeMap>
    with TickerProviderStateMixin {
  late final AnimatedMapController _animatedMapController;
  double _selectedRadius = 20.0;
  double _currentZoom = 12.0;
  final double _minZoom = 6.0;
  final double _maxZoom = 16.0;

  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this);
  }

  @override
  void dispose() {
    _animatedMapController.dispose();
    super.dispose();
  }

  void _centerOnUser() => _animatedMapController.animateTo(
        dest: _getUserPosition(widget.currentUser),
        zoom: _currentZoom,
      );

  void _zoomIn() {
    if (_currentZoom < _maxZoom) {
      setState(() => _currentZoom += 1);
      _animatedMapController.animatedZoomIn();
    }
  }

  void _zoomOut() {
    if (_currentZoom > _minZoom) {
      setState(() => _currentZoom -= 1);
      _animatedMapController.animatedZoomOut();
    }
  }

  LatLng _getUserPosition(ProfilUser user) => LatLng(
        user.latitude.getOrElse(() => 0.0),
        user.longitude.getOrElse(() => 0.0),
      );

  bool _hasValidLocation(ProfilUser user) =>
      user.latitude.isSome() && user.longitude.isSome();

  LatLngBounds _getBoundsFromRadius(LatLng center, double radiusInKm) {
    final dLat = radiusInKm / 111.1;
    final latRad = center.latitude * math.pi / 180.0;
    final dLon = radiusInKm / (111.1 * math.cos(latRad));
    return LatLngBounds(
      LatLng(center.latitude - dLat, center.longitude - dLon),
      LatLng(center.latitude + dLat, center.longitude + dLon),
    );
  }

  void _updateCameraForRadius(double radius) {
    final center = _getUserPosition(widget.currentUser);
    final bounds = _getBoundsFromRadius(center, radius);
    _animatedMapController.animatedFitCamera(
      cameraFit: CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(20),
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Marker _buildMarkerForUser(ProfilUser user) {
    final distance = DistanceHelper.calculateDistance(widget.currentUser, user);
    return Marker(
      width: 40.0,
      height: 40.0,
      point: _getUserPosition(user),
      child: MapMarker(
        user: user,
        isCurrentUser: false,
        distance: distance,
        catalogs: widget.userCatalogs[user.uid] ?? [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserMarker = Marker(
      width: 40.0,
      height: 40.0,
      point: _getUserPosition(widget.currentUser),
      child: MapMarker(
        user: widget.currentUser,
        isCurrentUser: true,
        distance: 0,
        catalogs: widget.userCatalogs[widget.currentUser.uid] ?? [],
      ),
    );

    final otherUsersMarkers = widget.users
        .where((u) => u.uid != widget.currentUser.uid)
        .where(_hasValidLocation)
        .where((u) =>
            DistanceHelper.calculateDistance(widget.currentUser, u) <=
            _selectedRadius)
        .map(_buildMarkerForUser)
        .toList();

    return Stack(
      children: [
        Padding(
          padding: AppSpacing.paddingAll,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FlutterMap(
              mapController: _animatedMapController.mapController,
              options: MapOptions(
                initialCenter: _getUserPosition(widget.currentUser),
                initialZoom: _currentZoom,
                minZoom: _minZoom,
                maxZoom: _maxZoom,
                onPositionChanged: (position, hasGesture) {
                  _currentZoom = position.zoom;
                },
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
                if (_selectedRadius < 99999.0)
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: _getUserPosition(widget.currentUser),
                        radius: _selectedRadius * 1000,
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
                    markers: otherUsersMarkers,
                    builder: (context, markers) =>
                        ClusterMarker(count: markers.length),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (otherUsersMarkers.isEmpty)
          Positioned(
            top: 30,
            left: 30,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.greenLight.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.greenDark.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Aucune plante trouvée dans ce rayon",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueGreen,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedRadius < 99999.0
                        ? "Élargissez le rayon de recherche pour découvrir plus de plantes autour de vous."
                        : "Soyez le premier à publier une plante dans l'application !",
                    style: const TextStyle(
                      color: AppColors.greyDark,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 40,
          left: 30,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(LucideIcons.map_pinned,
                  color: AppColors.blueGreen),
              onPressed: () async {
                final newRadius = await Navigator.push<double>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RadiusFilterPage(
                      initialRadius: _selectedRadius,
                      currentUser: widget.currentUser,
                    ),
                  ),
                );
                if (newRadius != null) {
                  setState(() {
                    _selectedRadius = newRadius;
                  });
                  _updateCameraForRadius(newRadius);
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: MapControls(
            onCenterOnUser: _centerOnUser,
            onZoomIn: _zoomIn,
            onZoomOut: _zoomOut,
          ),
        ),
      ],
    );
  }
}
