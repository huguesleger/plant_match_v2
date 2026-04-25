import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/cluster_marker.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_controls.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/map/map_marker.dart';
import 'package:plant_match_v2/features/catalog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

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

  Marker _buildMarkerForUser(ProfilUser user) {
    final distance = _calculateDistance(widget.currentUser, user);
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
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  // TODO: retirer cette options qui est juste pour tester sur le simulateur
                  cursorKeyboardRotationOptions:
                      CursorKeyboardRotationOptions.disabled(),
                ),
              ),
              children: [
                TileLayer(
                  userAgentPackageName: "com.plantmatch.app",
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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

  double _calculateDistance(ProfilUser currentUser, ProfilUser user) {
    if (user.uid == currentUser.uid) return 0.0;
    const Distance distance = Distance();
    final meters = distance.as(
      LengthUnit.Meter,
      _getUserPosition(currentUser),
      _getUserPosition(user),
    );
    return double.parse((meters / 1000).toStringAsFixed(2));
  }
}
