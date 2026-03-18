import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:plant_match_v2/core/theme/app_spacing.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/map_users/map_controls.dart';
import 'package:plant_match_v2/features/around_me_map/presentation/widgets/map_users/user_marker.dart';
import 'package:plant_match_v2/features/catolog/domain/entity/catalog.dart';
import 'package:plant_match_v2/features/profil/domain/entity/profil_user.dart';

class MapUsers extends StatefulWidget {
  const MapUsers({
    super.key,
    required this.users,
    required this.currentUser,
    required this.userCatalogs,
  });

  final List<ProfilUser> users;
  final ProfilUser currentUser;
  final Map<String, List<Catalog>> userCatalogs;

  @override
  State<MapUsers> createState() => _MapUsersState();
}

class _MapUsersState extends State<MapUsers> {
  late final MapController _mapController;
  double _currentZoom = 12.0;
  final double _minZoom = 6.0;
  final double _maxZoom = 16.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _centerOnUser() => setState(() {
        _mapController.move(_getUserPosition(widget.currentUser), _currentZoom);
      });

  void _zoomIn() {
    if (_currentZoom < _maxZoom) {
      setState(() {
        _currentZoom += 1;
        _mapController.move(_mapController.camera.center, _currentZoom);
      });
    }
  }

  void _zoomOut() {
    if (_currentZoom > _minZoom) {
      setState(() {
        _currentZoom -= 1;
        _mapController.move(_mapController.camera.center, _currentZoom);
      });
    }
  }

  LatLng _getUserPosition(ProfilUser user) => LatLng(user.latitude ?? 0.0, user.longitude ?? 0.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: AppSpacing.paddingAll,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _getUserPosition(widget.currentUser),
                initialZoom: _currentZoom,
              ),
              children: [
                TileLayer(
                  userAgentPackageName: "com.plantmatch.app",
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                MarkerLayer(
                  markers: widget.users.map((user) {
                    final distance = _calculateDistance(widget.currentUser, user);
                    return Marker(
                      width: 40.0,
                      height: 40.0,
                      point: _getUserPosition(user),
                      child: UserMarker(
                        user: user,
                        isCurrentUser: user.uid == widget.currentUser.uid,
                        distance: distance,
                        catalogs: widget.userCatalogs[user.uid] ?? [],
                      ),
                    );
                  }).toList(),
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
    double meters = distance.as(
      LengthUnit.Meter,
      LatLng(currentUser.latitude ?? 0.0, currentUser.longitude ?? 0.0),
      LatLng(user.latitude ?? 0.0, user.longitude ?? 0.0),
    );
    return double.parse((meters / 1000).toStringAsFixed(2));
  }
}
